class Video
{
  String filename;
  String id;
  String description;
  String title;
  Video(String filename, String id, String description, String title)
  {
    this.filename = filename;
    this.id = id;
    this.description = description;
    this.title = title;
  }

  String getVideoLink()
  {
    return "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  }
}