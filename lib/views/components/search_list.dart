
import 'package:flutter/material.dart';
import 'package:starterkit/utils/styles.dart';

class SearchList extends StatefulWidget {

  final String title;
  final dataSource;
  final String displayData;
  final int selectedId;
  final ValueSetter<dynamic> onSelected;

  SearchList(this.title, this.dataSource, {this.displayData = 'name', this.selectedId = -1, @required this.onSelected});

  _SearchListState createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {

  TextEditingController _textEditingController = TextEditingController();
  bool _firstSearch = true;
  String _query = "";
  var filteredList;
  int selectedId;
  int selectedIndex;

  @override
  void initState() {
    super.initState();
    filteredList = List.from(widget.dataSource);
    selectedId = widget.selectedId;
    selectedIndex = getItemIndex(selectedId);
  }

  getItemIndex(id) {
    var elements;
    if (_firstSearch) {
      elements = List.from(widget.dataSource);
    }
    else {
      elements = List.from(filteredList);
    }

    for (int i=0; i<elements.length; i++) {
      if (elements[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  onItemSelected(int index) {
    var elements;
    if (_firstSearch) {
      elements = List.from(widget.dataSource);
    }
    else {
      elements = List.from(filteredList);
    }

    var element = elements[index];
    if (element != null) {
      setState(() {
        selectedIndex = index;
        selectedId = element.id;
      });

      widget.onSelected(element);
    }
  }

  _SearchListState() {
    _textEditingController.addListener(() {
      if (_textEditingController.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _textEditingController.text;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(bottom: 5, top: 5),
              child: Text(widget.title, style: Styles.h1,),
            ),
            _createSearchView(),
            _firstSearch ? _createListView(widget.dataSource) : _performSearch()
          ],
        ),
      ),
    );
  }

  //Create a SearchView
  Widget _createSearchView() {
    return new Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0)),
      child: new TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: "Buscar",
          hintStyle: Styles.defaultStyle,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Perform actual search
  Widget _performSearch() {
    filteredList = [];
    for (int i = 0; i < widget.dataSource.length; i++) {
      var item = widget.dataSource[i];

      if (item.get(widget.displayData).toLowerCase().contains(_query.toLowerCase())) {
        filteredList.add(item);
      }
    }
    return _createListView(filteredList);
  }

  //Create the Filtered ListView
  Widget _createListView(itemList) {
    return itemList.isNotEmpty
        ? new Flexible(
          child: new ListView.builder(
            itemCount: itemList.length,
            itemBuilder: (BuildContext context, int index) {
              return new Card(
                color: index == selectedIndex ? Styles.rightMessageAkaColor : Colors.white,
                elevation: 5.0,
                child: ListTile(
                  title: Container(
                    margin: EdgeInsets.all(15.0),
                    child: new Text("${itemList[index].get(widget.displayData)}", style: Styles.defaultStyle,),
                  ),
                  onTap: () => onItemSelected(index),
                )
              );
            }),
          )
        : Center(child: Image.asset("assets/images/no-data.png", height: MediaQuery.of(context).size.height/5,));
  }
}