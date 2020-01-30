package ebiz.lotus.administrator.eaglebiz.model;

public class LocationDataModel {

    int idM;
    String device_idM,creadted_dateM;
    String latiM,longiM;

    public LocationDataModel(){

    }

    public LocationDataModel(int id, String device_id, String lati, String longi, String creadted_date) {
        this.idM=id;
        this.device_idM=device_id;
        this.latiM=lati;
        this.longiM=longi;
        this.creadted_dateM=creadted_date;

    }

    public int getIdM() {
        return idM;
    }

    public void setIdM(int idM) {
        this.idM = idM;
    }

    public String getDevice_idM() {
        return device_idM;
    }

    public void setDevice_idM(String device_idM) {
        this.device_idM = device_idM;
    }

    public String getCreadted_dateM() {
        return creadted_dateM;
    }

    public void setCreadted_dateM(String creadted_dateM) {
        this.creadted_dateM = creadted_dateM;
    }

    public String getLatiM() {
        return latiM;
    }

    public void setLatiM(String latiM) {
        this.latiM = latiM;
    }

    public String getLongiM() {
        return longiM;
    }

    public void setLongiM(String longiM) {
        this.longiM = longiM;
    }
}
