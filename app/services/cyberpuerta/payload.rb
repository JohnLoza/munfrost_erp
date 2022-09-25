# frozen_string_literal: true

require 'roo'

module Cyberpuerta
  class Payload < ApplicationService
    def initialize(import_file_path)
      @import_file_path = import_file_path
      @payload = []
    end

    def call
      xlsx = Roo::Spreadsheet.open(@import_file_path, extension: :xlsx)
      rows = processable_rows(xlsx)
      process_rows(xlsx, rows)
      @payload
    end

    private

    def process_rows(xlsx, rows)
      rows.each do |row_index|
        row = xlsx.sheet(0).row(row_index)
        @payload.push({
          title: row[1],
          manufacturer_sku: row[2],
          sku: row[3],
          warehouses: {
            '1': {
              stock: row[4]
            }
          },
          price: abstract_taxes(row[5]),
          manufacturer: 'Munfrost',
          currency: 'MXN',
        })
      end
    end

    def processable_rows(xlsx)
      xlsx.sheet(0).info.match(/Last row: (\d+)/)
      last_row = $1
      raise(ArgumentError, 'No se logro determinar cual es la última fila') unless last_row.present?

      last_row = last_row.to_i
      raise(ArgumentError, "El archivo está vacío o no tiene suficiente información") unless last_row > 1

      2..last_row
    end

    def ensure_float(amount)
      return amount if amount.is_a?(Float)
      raise(ArgumentError, 'No se identifica el tipo de dato del precio') unless amount.is_a?(String)

      amount = amount.gsub(/\$|,/, '').strip.to_f
      raise(ArgumentError, 'El precio no puede ser 0.0') if amount.zero?

      amount
    end

    def abstract_taxes(amount)
      amount_without_taxes = ensure_float(amount) / 1.16
      amount_without_taxes.round(2)
    end
  end
end
