import 'dart:convert';

import 'package:sanity_test/app_exceptions.dart';
import 'package:sanity_test/http_client.dart';
import 'package:http/http.dart' as http;

class SanityClient {
  factory SanityClient({
    required String projectId,
    required String dataset,
    String? token,
    bool useCdn = true,
  }) {
    final HttpClient client = HttpClient(token);

    return SanityClient._createInstance(
      client,
      projectId: projectId,
      dataset: dataset,
      useCdn: useCdn,
    );
  }

  SanityClient._createInstance(
    this._client, {
    required this.projectId,
    required this.dataset,
    this.token,
    this.useCdn = true,
  });

  final HttpClient _client;
  final String projectId;
  final String dataset;
  final String? token;
  final bool useCdn;

  Uri _buildUri({required String query, Map<String, dynamic>? params}) {
    final Map<String, dynamic> queryParameters = <String, dynamic>{
      'query': query,
      if (params != null) ...params,
    };
    // return Uri(
    //   scheme: 'https',
    //   host: '$projectId.${useCdn ? 'apicdn' : 'api'}.sanity.io',
    //   path: '/v1/data/query/$dataset',
    //   queryParameters: queryParameters,
    // );
    // https://zp7mbokg.api.sanity.io/v2021-06-07/data/query/production?query=*[0]
    // https://52b2mvj6.api.sanity.io/v2021-10-21/data/query/production?query=%0A*%5B_type%20%3D%3D%20%27corporateAnnouncement%27%5D%0A%0A
    return Uri(
      scheme: 'https',
      host: '52b2mvj6.api.sanity.io',
      path: 'v2021-10-21/data/query/$dataset',
      queryParameters: queryParameters,
    );
  }

  dynamic _returnResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        final Map<String, dynamic> responseJson = jsonDecode(response.body);
        return responseJson['result'];
      case 400:
        throw BadRequestException(response.body.toString());
      case 401:
      case 403:
        throw UnauthorizedException(response.body.toString());
      case 500:
      default:
        throw FetchDataException('Error occured while communication with server with status code: ${response.statusCode}');
    }
  }

  Future<dynamic> fetch({required String query, Map<String, dynamic>? params}) async {
    print("fetch");
    final Uri uri = _buildUri(query: query, params: params);
    print(uri);
    final http.Response response = await _client.get(uri);
    return _returnResponse(response);
  }
}
