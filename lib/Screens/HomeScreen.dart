import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:news_app/Screens/Custom_Widgets/newsCategoryWidget.dart';
import 'package:news_app/Screens/detailed_News.dart';
import 'package:news_app/Screens/newsCategories.dart';
import 'package:news_app/State_Management/provider_helper.dart';
import 'package:news_app/api_Management/Get_Apis/news_Headlines_Api_call.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  DateFormat myformat = DateFormat('dd-MM-yyyy');
  String selectedCategory = 'general';

  List<String> Headlines = ['BBC-NEWS', 'Al-Jazeera-English'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProviderHelper>(context, listen: false);
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => newsCategoriesScreen()),
            );
          },
          child: Container(
            margin: EdgeInsets.all(15),
            child: Image.asset('assets/3x3_dots_without_background.png'),
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: Icon(Icons.more_vert, size: 30, color: Colors.black),
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('CNN'),
                  onTap: () {
                    provider.selectedHeadline('cnn');
                  },
                ),
                PopupMenuItem(
                  child: Text('BBC-NEWS'),
                  onTap: () {
                    provider.selectedHeadline('bbc-news');
                  },
                ),
                PopupMenuItem(
                  child: Text('Ary-News'),
                  onTap: () {
                    provider.selectedHeadline('ary-news');
                  },
                ),
                PopupMenuItem(
                  child: Text('Al-Jazeera-English'),
                  onTap: () {
                    provider.selectedHeadline('al-jazeera-english');
                  },
                ),
                PopupMenuItem(
                  child: Text('Crypto-Coins-News'),
                  onTap: () {
                    provider.selectedHeadline('crypto-coins-news');
                  },
                ),
              ];
            },
          ),
        ],
        centerTitle: true,
        title: Text(
          'News',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      body: Selector<ProviderHelper, bool>(
        selector: (_, provider) => provider.getLoading,
        builder: (context, value, child) {
          debugPrint("homescreen selector called");
          return value
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    HeadLineWidget(context),
                    Newscategorywidget(isScrollable: false, myformat: myformat),
                  ],
                );
        },
      ),
    );
  }
}

Widget HeadLineWidget(BuildContext context) {
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  final HLProvider = Provider.of<ProviderHelper>(context, listen: false);

  return Container(
    // color: Colors.amber,
    padding: const EdgeInsets.symmetric(vertical: 15),
    height: height * 0.65,
    width: width * 1,
    child: Selector<ProviderHelper, String>(
      selector: (_, myProvider) => myProvider.getSource,
      builder: (_, value, __) {
        debugPrint('headline selector called');
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: HLProvider.headlines.articles!.length,
          itemBuilder: (context, index) {
            final title = HLProvider.headlines.articles![index].title
                .toString();
            final description = HLProvider
                .headlines
                .articles![index]
                .description
                .toString();
            final datetime = DateTime.parse(
              HLProvider.headlines.articles![index].publishedAt.toString(),
            );
            String preAuthor = HLProvider.headlines.articles![index].author
                .toString();
            final author = (preAuthor == "null" || preAuthor == '')
                ? "Unknown"
                : preAuthor;
            final image = HLProvider.headlines.articles![index].urlToImage
                .toString();

            return InkWell(
              borderRadius: BorderRadius.circular(10),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailedNewsScreen(
                      headlineTitle: title,
                      description: description,
                      author: author,
                      date: datetime,
                      imageUrl: image,
                      headlineType: true,
                    ),
                  ),
                );
              },
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(10),
                      child: SizedBox(
                        height: height * 0.65,
                        width: width * 0.88,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: image,
                          placeholder: (context, url) {
                            return const Center(
                              child: SpinKitFadingCircle(color: Colors.yellow),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return const Image(
                              image: AssetImage('assets/news.jpg'),
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  customCard(title, author, datetime, context),
                ],
              ),
            );
          },
        );
      },
    ),
  );
}

Widget customCard(title, author, datetime, BuildContext context) {
  DateFormat myformat = DateFormat('dd-MM-yyyy');
  final height = MediaQuery.of(context).size.height;
  final width = MediaQuery.of(context).size.width;
  return Positioned(
    left: width * 0.05,
    bottom: height * 0.02,
    child: Card(
      color: Colors.white,
      child: SizedBox(
        height: height * 0.2,
        width: width * 0.8,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                title,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    // color: Colors.amber,
                    width: 150,
                    child: Text(
                      author,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Text(
                    myformat.format(datetime),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
