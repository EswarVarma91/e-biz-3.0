package ebiz.lotus.administrator.eaglebiz.model;

public class LocationDataModel {

    int idM;
    String deviceId,date;
    String latitude,longitude;

    public LocationDataModel(){

    }

    public LocationDataModel(int id, String device_id, String lati, String longi, String creadted_date) {
        this.idM=id;
        this.deviceId=device_id;
        this.latitude=lati;
        this.longitude=longi;
        this.date=creadted_date;

    }

    public int getIdM() {
        return idM;
    }

    public void setIdM(int idM) {
        this.idM = idM;
    }

    public String getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(String deviceId) {
        this.deviceId = deviceId;
    }

    public String getDate() {
        return date;
    }

    public void setDate(String date) {
        this.date = date;
    }

    public String getLatitude() {
        return latitude;
    }

    public void setLatitude(String latitude) {
        this.latitude = latitude;
    }

    public String getLongitude() {
        return longitude;
    }

    public void setLongitude(String longitude) {
        this.longitude = longitude;
    }
}
