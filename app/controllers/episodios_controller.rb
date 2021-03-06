class EpisodiosController < ApplicationController
  layout "geral"
  before_filter :authorize, :only => [:new, :create, :edit, :update, :destroy]

  # GET /episodios
  # GET /episodios.xml
  def index
    @episodios = Episodio.paginate :page => params[:page], :order => "numero DESC, parte DESC"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @episodios }
    end
  end


  def quick_load
    
    respond_to do |format|
      format.html { redirect_to(episodio_path(:id => params[:episodio][:full_id])) }
    end
    
  end
  # GET /episodios/1
  # GET /episodios/1.xml
  def show
    
    @episodio = get_by_numero(params[:id])
    
    #For embedded forms
    @track = @episodio.tracks.build
    @quote = @episodio.quotes.build
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @episodio }
    end
  end

  # GET /episodios/new
  # GET /episodios/new.xml
  def new
    @episodio = Episodio.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @episodio }
    end
  end

  # GET /episodios/1/edit
  def edit
    @episodio = get_by_numero(params[:id])
  end

  # POST /episodios
  # POST /episodios.xml
  def create
    @episodio = Episodio.new(params[:episodio])

    respond_to do |format|
      if @episodio.save
        flash[:notice] = 'Episodio was successfully created.'
        format.html { redirect_to(@episodio) }
        format.xml  { render :xml => @episodio, :status => :created, :location => @episodio }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @episodio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /episodios/1
  # PUT /episodios/1.xml
  def update
    @episodio = get_by_numero(params[:id])

    respond_to do |format|
      if @episodio.update_attributes(params[:episodio])
        flash[:notice] = 'Episodio was successfully updated.'
        format.html { redirect_to(@episodio) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @episodio.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /episodios/1
  # DELETE /episodios/1.xml
  def destroy
    @episodio = get_by_numero(params[:id])
    @episodio.destroy

    respond_to do |format|
      format.html { redirect_to(episodios_url) }
      format.xml  { head :ok }
    end
  end
  
  def get_by_numero(id)
    #break number appart into numero/parte
    parts = id.scan(/[a-zA-Z]+|[0-9]+/)
    
    #search by number or number+part
    if parts.size() < 2
      @episodio = Episodio.first(:conditions => ["numero = ?", parts.shift])
    else
      @episodio = Episodio.first(:conditions => ["numero = ? AND parte = ?", parts.shift, parts.shift])
    end
    
    #None found, search by ID
    if @episodio.nil? 
      @episodio = Episodio.find(params[:id])
    end

    #Return found Episodio
    @episodio
  end
end
