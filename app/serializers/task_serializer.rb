class TaskSerializer < ActiveModel::Serializer
  attributes :id, :display_title, :title, :list_base_id, :position
  attributes :completed, :archived, :due_date, :full_date

  def archived
    object.archived?
  end

  def include_due_date?
    object.due_date
  end

  def due_date
    object.due_date.strftime("%m/%d")
  end

  def include_full_date?
    object.due_date
  end

  def full_date
    object.due_date.strftime("%y/%m/%d")
  end
end
