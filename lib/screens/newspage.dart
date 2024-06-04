import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/news.dart';
import '../providers/apiservice.dart';
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  final String Category;

  const NewsPage({Key? key, required this.Category}) : super(key: key);
  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage>
    with SingleTickerProviderStateMixin {
  late List<Datum> _newsList = [];
  late List<Datum> _searchResult = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    String category = widget.Category;
    var news = await ApiRoutes.instance.loadCategory(category);
    setState(() {
      _newsList = News.fromJson(news).data!;
    });
  }

  void _searchNews(String query) {
    List<Datum> searchResult = _newsList
        .where((news) =>
        news.title!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _searchResult = searchResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    String category = widget.Category;
    return Scaffold(
      appBar: AppBar(
        title: _isSearching ? _buildSearchField() : Text('Berita $category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: _buildAppBarActions(),
        backgroundColor: Color(0xff5e41cb),
        centerTitle: true,
      ),
      body: Container(
        child: _isSearching ? _buildSearchResults() : _buildNewsList(),
      ),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Cari berita...',
        hintStyle: TextStyle(color: Colors.white70),
      ),
      style: TextStyle(color: Colors.white),
      onChanged: (query) {
        _searchNews(query);
      },
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_isSearching) {
      return [
        IconButton(
          icon: Icon(Icons.cancel, color: Colors.white,),
          onPressed: () {
            setState(() {
              _isSearching = false;
              _searchResult.clear();
            });
          },
        )
      ];
    } else {
      return [
        IconButton(
          icon: Icon(Icons.search, color: Colors.white,),
          onPressed: () {
            setState(() {
              _isSearching = true;
            });
          },
        )
      ];
    }
  }

  Widget _buildSearchResults() {
    return _searchResult.isNotEmpty
        ? ListView.builder(
      itemCount: _searchResult.length,
      itemBuilder: (context, index) {
        return _buildItemCategory(_searchResult[index]);
      },
    )
        : Center(
      child: Text('Tidak ada hasil'),
    );
  }

  Widget _buildNewsList() {
    return _newsList.isNotEmpty
        ? ListView.builder(
      itemCount: _newsList.length,
      itemBuilder: (context, index) {
        return _buildItemCategory(_newsList[index]);
      },
    )
        : _buildLoadingSection();
  }

  Widget _buildItemCategory(Datum news) {
    var df = news.isoDate!;
    return InkWell(
      onTap: () {
        launchURL(news.link!);
      },
      splashColor: Color(0xff130160),
      borderRadius: BorderRadius.circular(16),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(news.image.large!),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 50,
                child: Text(
                  news.title!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 60,
                child: Text(
                  news.contentSnippet!,
                  textAlign: TextAlign.justify,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                height: 40,
                child: Text(
                  "Diunggah pada : " +
                      DateFormat('dd-MM-yyyy').format(df),
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingSection() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Future<void> launchURL(String url) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      throw "Couldn't launch $_url";
    }
  }
}