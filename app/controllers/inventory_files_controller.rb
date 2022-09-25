# frozen_string_literal: true

class InventoryFilesController < AuthenticatedController
  def index
    @inventory_files = InventoryFile.recent.last(30)
  end

  def create
    if InventoryFile.create(inventory_file_params)
      # TODO set success message
    else
      # TODO set error message
    end
    redirect_to(root_path)
  end

  private

  def inventory_file_params
    params.require(:inventory_file).permit(:file)
  end
end
