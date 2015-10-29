class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]

  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = Task.all
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # GET /tasks/works
  # GET /tasks/works.json
  def works
    works = Work.where(:task_id => params[:id], :created_at => Time.now.beginning_of_month..Time.now.end_of_month)
    @works = works.map {|item| {
      id: item.id,
      start: item.starttime,
      end: item.endtime,
      duration: (item.endtime) ? item.endtime.to_i - item.starttime.to_i : 0 ,
      duration_s: (item.endtime) ? get_time_diff( item.starttime.to_i, item.endtime.to_i) : get_time_diff(0, 0) ,
    }}

    #see http://www.xmisao.com/2014/03/25/how-to-sum-array-of-numbers-in-ruby.html
    @sum = get_time(@works.map {|item| item[:duration] }.inject(:+))
  end



  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def get_time day
      hours = day.divmod(60*60)
      mins = hours[1].divmod(60)

      "#{hours[0].to_i}h #{mins[0].to_i}m #{mins[1]}s"
    end
    def get_time_diff day1, day2
      hours = (day2 - day1).divmod(60*60)
      mins = hours[1].divmod(60)

      "#{hours[0].to_i}h #{mins[0].to_i}m #{mins[1]}s"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params[:task]
    end
end
