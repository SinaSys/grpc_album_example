import 'package:grpc/grpc.dart';
import 'package:grpc_album_example/src/generated/album.pbgrpc.dart';

void main() async {
  final channel = ClientChannel(
    'localhost',
    port: 500,
    options: const ChannelOptions(credentials: ChannelCredentials.insecure()),
  );

  final stub = AlbumServiceClient(channel);

 try{
   // unary style responses
 //  var response = await stub.getAlbums(AlbumRequest());
  // print('Response received: ${response.writeToJson()}');

   var response = await stub.getAlbums(AlbumRequest()..id = 1);
   print("Sina response is : ${response.albums[0].title}");
   print('Response received: ${response.writeToJsonMap()}');

   var response2 = await stub.getAlbumsWithPhotos(AlbumRequest()..id = 3);
   print('Got response! $response2');
   print('Got response! ${response2.albums[0]}');
   print('Got response! ${response2.albums[0].writeToJson()}');
   print('Got response! ${response2.albums[0].writeToJsonMap()}');

   // Streaming server rpc style responses
   var photoStream = stub.getPhotos(AlbumRequest());
   await for (var photo in photoStream) {
     print('Received photo! ${photo.url}');
   }

   photoStream = stub.getPhotos(AlbumRequest()..id = 3);
   await for (var photo in photoStream) {
     print('Received filtered photo! ${photo.url}');
   }

 }catch(e){
   print('Caught error: $e');
 }
  await channel.shutdown();
}