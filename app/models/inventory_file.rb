# frozen_string_literal: true

class InventoryFile < ApplicationRecord
  has_one_attached(:file)
  has_one_attached(:payload)

  validates(:file, presence: true)

  scope :recent, -> { order(created_at: :desc) }

  def sync_to_cyberpuerta
    save_payload
    Cyberpuerta::Sync.call(read_payload)
    update!(error_msg: nil, error_location: nil)
  rescue => error
    Rails.logger.error("Got an error while syncing to cyberpuerta")
    Rails.logger.error("#{error.message} | #{error.backtrace.first}")
    update!(error_msg: error.message, error_location: error.backtrace.first)
    raise(error)
  end

  def read_payload
    return unless payload.attached?

    raw_payload = File.read(payload_attachment_path)
    JSON.parse(raw_payload)
  end

  private

  def file_attachment_path
    @file_attachment_path ||= ActiveStorage::Blob.service.path_for(file.key)
  end

  def payload_attachment_path
    @payload_attachment_path ||= ActiveStorage::Blob.service.path_for(payload.key)
  end

  def save_payload
    return if payload.attached?

    filename = "#{Time.now.to_i}.json"
    payload_filepath = Rails.root.join("tmp/#{filename}")
    cyberpuerta_payload = Cyberpuerta::Payload.call(file_attachment_path)
    File.write(payload_filepath, cyberpuerta_payload.to_json)
    payload.attach(io: File.open(payload_filepath), filename: filename)
  end
end
