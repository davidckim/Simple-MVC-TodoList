# What classes do you need?

# Remember, there are four high-level responsibilities, each of which have multiple sub-responsibilities:
# 1. Gathering user input and taking the appropriate action (controller)
# 2. Displaying information to the user (view)
# 3. Reading and writing from the todo.csv file (model)
# 4. Manipulating the in-memory objects that model a real-life TODO list (domain-specific model)

# Note that (4) is where the essence of your application lives.
# Pretty much every application in the universe has some version of responsibilities (1), (2), and (3).

#Pseudocode
# Create a new class 'Tasks' that will initalize with a new task.
#     Initalize the task class with a number and the text of the task itself.
# Create a new class 'List' that will initialize an empty to do list.
# Create methods within this list class that will manipulate the data.
#     An add method that will add a task to the list.
#     A method that will list the tasks on a TODO list.
#     A method that will delete a task from the TODO list.
#     A method that will 'complete' a task on the TODO list.
#       - add (COMPLETED) next to the completed task.
# For the command-line arguments, create an inferface for command-line arguments.
#     Depending on what the user inputs, it will take the appropriate action.
#       - See List
#       - Add Task
#       - Remove Task
#       - Complete a Task
#       - Create a new list
#       - Clear Current List
# end

require 'csv'

# Model ####################################################################################

class Task
  attr_accessor :task_name

  def initialize(task_name)
    @task_name = task_name
  end
end

# Controller ####################################################################################

class List
  attr_accessor :todo_list

  def initialize
    @view = View.new
    @todo_list = []
    CSV.foreach('todo.csv') do |row|
      @todo_list << Task.new(row)
    @view.clear_and_home
    end
  end

  def start
    @view.start_model
    command = gets.chomp
    case command.downcase
    when "view list"
      display_list
      start
    when "add"
      add
      start
    when "delete"
      delete
      start
    when "complete"
      mark_as_complete
      start
    when "clear list"
      clear_list
      start
    when "exit"
      exit
    end
  end
end

  def add
    @view.add_question
    task_name = gets.chomp
    @todo_list << Task.new([task_name])
    @view.add_command(@todo_list)
    @view.clear_and_home
    @view.make_list_pretty(@todo_list)
  end

  def delete
    @view.delete_question
    task_list_number = gets.chomp
  	@todo_list.delete_at(task_list_number.to_i - 1)
    @view.delete_command(@todo_list)
    @view.clear_and_home
    @view.make_list_pretty(@todo_list)
  end

  def display_list
    @view.clear_and_home
    @view.make_list_pretty(@todo_list)
  end

  def mark_as_complete
    @view.mark_complete_question
    task_list_number = gets.chomp
  	@todo_list[task_list_number.to_i - 1].task_name << "       <<< COMPLETED >>>"
  end

  def clear_list
    @view.clear_list_confirm
    response = gets.chomp
    if response.downcase == "yes"
      @view.clear_and_home
      @todo_list.clear
      @view.clear_list_yes(@todo_list)
    elsif response.downcase == "no"
      @view.clear_and_home
      @view.clear_list_no(@todo_list)
    else
      @view.clear_list_not_valid
  end

end

# View ####################################################################################

class View
  def start_model
    puts "-------------------------------------------------------------"
    puts "Welcome to ToDoList v192. Please enter a following command"
    puts "-------------------------------------------------------------"
    puts "- View List"
    puts "- Add"
    puts "- Delete"
    puts "- Complete"
    puts "- Clear List"
    puts "- Save List"
    puts "- Exit"
    puts "--------------------------------------------------------------"
    puts "Please enter a command:"
  end

  def add_command(todolist)
    puts "-------------------------------------------------------------"
    puts "Successfully added task(s) to ToDo list."
    puts "-------------------------------------------------------------"
    make_list_pretty(todolist)
  end

  def add_question
    puts "-------------------------------------------------------------"
    puts "Please enter task to be added:"
    puts "-------------------------------------------------------------"
  end

  def delete_command(todolist)
    puts "-------------------------------------------------------------"
    puts "Successfully deleted task."
    puts "-------------------------------------------------------------"
    make_list_pretty(todolist)
  end

  def delete_question
    puts "-------------------------------------------------------------"
    puts "Please enter task number to delete:"
    puts "-------------------------------------------------------------"
  end

  def mark_complete_question
    puts "-------------------------------------------------------------"
    puts "Please enter task number that has been completed:"
    puts "-------------------------------------------------------------"
  end

  def mark_complete_command(todolist)
    puts "-------------------------------------------------------------"
    puts "Task number #{task_list_number}, has been marked as complete!"
    puts "-------------------------------------------------------------"
    make_list_pretty(todolist)
  end

  def make_list_pretty(todolist)
    puts "-------------------------------------------------------------"
    puts "Here is your list up-to-date!"
    puts "-------------------------------------------------------------"
    counter = 1
    todolist.each do |task|
      puts "#{counter}.".ljust(4) + "#{task.task_name.join}"
      counter += 1
    end
  end

  def clear_list_confirm
    puts "-------------------------------------------------------------"
    puts "You are about to clear your list. Are you sure?"
    puts "-------------------------------------------------------------"
  end

  def clear_list_yes(todolist)
    puts "-------------------------------------------------------------"
    puts "List has been cleared!"
    puts "-------------------------------------------------------------"
    make_list_pretty(todolist)
  end

  def clear_list_no(todolist)
    puts "-------------------------------------------------------------"
    puts "List has not been cleared."
    puts "-------------------------------------------------------------"
    make_list_pretty(todo_list)
  end

  def clear_list_not_valid
    Puts "That is not a valid response. Please respond with 'yes' or 'no'"
    clear_list_confirm
  end

  def clear_and_home
    clear_screen!
    move_to_home!
  end

  def clear_screen!
    print "\e[2J"
  end

  def move_to_home!
    print "\e[H"
  end

end


# Design time
# =====================================
# Run time

list = List.new
list.start



# Driver Test Code
# ==============================================
# list.display_list
# list.add("Drink coffee")
# list.delete(12)
# list.mark_as_complete(3)
# list.mark_as_complete(1)
# list.add("Catch a world record tuna")
# list.add("drink some coffee.")
# list.add("play some football.")
# list.add("Watch the Denver Broncos win the SuperBowl before I die.")
# list.clear_list










