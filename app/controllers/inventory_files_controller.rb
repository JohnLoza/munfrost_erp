# frozen_string_literal: true

class InventoryFilesController < AuthenticatedController
  def index
    @inventory_files = InventoryFile.recent.last(30)
  end

  def create
    inv_file = InventoryFile.create!(inventory_file_params)
    inv_file.sync_to_cyberpuerta
    flash[:success] = 'Sincronización exitosa'
    redirect_to(inventory_files_path)
  rescue => error
    flash[:danger] = error.message
    redirect_to(inventory_files_path)
  end

  private

  def inventory_file_params
    params.require(:inventory_file).permit(:file)
  end
end
