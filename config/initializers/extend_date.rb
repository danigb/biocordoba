class Date
  #Mostrar un dia con formato correcto
  def localize
    I18n.localize(self, :format => '%A %d')
  end
end
