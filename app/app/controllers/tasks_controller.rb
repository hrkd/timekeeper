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
    require 'holiday_jp'

    time =  Time.local(params[:year], params[:month])
    holiday = HolidayJp.between(time.beginning_of_month, time.end_of_month)
    works = Work.where(:task_id => params[:id], :starttime => time.beginning_of_month..time.end_of_month).order("starttime DESC")
    @works = works.map {|item| {
      start: item.starttime,
      end: item.endtime,
      duration: get_duration(item.starttime, item.endtime, item.is_exist_breaktime) ,
      duration_s: get_duration_to_s(get_duration(item.starttime, item.endtime, item.is_exist_breaktime)),
      break: item.is_exist_breaktime,
    }}

    for num in 1..3 do
      print("num = ", num, "¥n")
    end

    @days = time.at_end_of_month.day - holiday.length - get_this_sat_sun_days(time)
    seconds = @days*8*60*60

    #see http://www.xmisao.com/2014/03/25/how-to-sum-array-of-numbers-in-ruby.html
    sum = @works.map {|item| item[:duration] }.inject(:+)
    @year = params[:year]
    @month= params[:month]
    @sum = (sum) ? get_duration_to_s(sum):0

    @max = get_duration_to_s(seconds)
    @persent = (sum.to_f / seconds.to_f * 100).round

    @max_amount = 45

    @amount = 45 * (@persent.to_f / 100)

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
    def get_duration starttime, endtime, breaktime
      if(endtime) then
        if(breaktime) then
          endtime.to_i - starttime.to_i - (60*60)
        else
          endtime.to_i - starttime.to_i
        end
      else
        0
      end
    end

    def get_duration_to_s day
      hours = day.divmod(60*60)
      mins = hours[1].divmod(60)

      "#{hours[0].to_i}h-#{mins[0].to_i}m-#{mins[1]}s"
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params[:task]
    end


    def get_this_sat_sun_days time
      num = 1
      endday = time.end_of_month.strftime("%e")
      month = Array.new
      while num <= endday.to_i do
        month << Time.local(params[:year], params[:month], num.to_s).wday
        num = num+1
      end
      month.select {|item| item == 0 || item == 6}.length
    end

end
