import 'http_client.dat';base64 encode the api_service.dap file.
class ApiService {
    getApi(channel: HTTPClasses.Channel) {
        return HTTPClasses.get(channel);
   }
}