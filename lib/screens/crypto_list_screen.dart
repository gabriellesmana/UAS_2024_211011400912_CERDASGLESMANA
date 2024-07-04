import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../providers/crypto_provider.dart';

class CryptoListScreen extends StatefulWidget {
  @override
  _CryptoListScreenState createState() => _CryptoListScreenState();
}

class _CryptoListScreenState extends State<CryptoListScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/background.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          _controller.value.isInitialized
              ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller.value.size.width,
                      height: _controller.value.size.height,
                      child: VideoPlayer(_controller),
                    ),
                  ),
                )
              : Container(),
          Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                title: Text('TokoCrypDas', style: TextStyle(color: Colors.white)),
                actions: [
                  IconButton(
                    icon: Icon(Icons.search, color: Colors.white),
                    onPressed: () {
                      // Implement search functionality here
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.notifications, color: Colors.white),
                    onPressed: () {
                      // Implement notification functionality here
                    },
                  ),
                ],
              ),
              Expanded(
                child: FutureBuilder(
                  future: Provider.of<CryptoProvider>(context, listen: false).fetchCryptos(),
                  builder: (ctx, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.white)));
                    } else {
                      return Consumer<CryptoProvider>(
                        builder: (ctx, cryptoProvider, _) => SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const <DataColumn>[
                                DataColumn(label: Text('#', style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text('Name', style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text('Price', style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text('1h %', style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text('24h %', style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text('7d %', style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text('Market Cap', style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text('Volume(24h)', style: TextStyle(color: Colors.white))),
                                DataColumn(label: Text('Circulating Supply', style: TextStyle(color: Colors.white))),
                              ],
                              rows: cryptoProvider.cryptos.map((crypto) {
                                return DataRow(cells: [
                                  DataCell(Text(crypto.rank.toString(), style: TextStyle(color: Colors.white))),
                                  DataCell(Row(
                                    children: [
                                      SizedBox(width: 8),
                                      Text(crypto.name, style: TextStyle(color: Colors.white)),
                                      SizedBox(width: 8),
                                      Text(crypto.symbol, style: TextStyle(color: Colors.white)),
                                    ],
                                  )),
                                  DataCell(Text('\$${crypto.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green))),
                                  DataCell(Text('${crypto.change1h.toStringAsFixed(2)}%', style: TextStyle(color: crypto.change1h >= 0 ? Colors.green : Colors.red))),
                                  DataCell(Text('${crypto.change24h.toStringAsFixed(2)}%', style: TextStyle(color: crypto.change24h >= 0 ? Colors.green : Colors.red))),
                                  DataCell(Text('${crypto.change7d.toStringAsFixed(2)}%', style: TextStyle(color: crypto.change7d >= 0 ? Colors.green : Colors.red))),
                                  DataCell(Text('\$${crypto.marketCap.toStringAsFixed(2)}', style: TextStyle(color: Colors.white))),
                                  DataCell(Text('\$${crypto.volume24h.toStringAsFixed(2)}', style: TextStyle(color: Colors.white))),
                                  DataCell(Text('${crypto.circulatingSupply.toStringAsFixed(2)} ${crypto.symbol}', style: TextStyle(color: Colors.white))),
                                ]);
                              }).toList(),
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
