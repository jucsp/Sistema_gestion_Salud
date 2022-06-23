import 'package:flutter/material.dart';

class TabPerfil extends StatefulWidget {
  TabPerfil(this.colorVal);
  int colorVal;
  @override
  _TabPerfilState createState() => _TabPerfilState();
}

class _TabPerfilState extends State<TabPerfil> with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    void _handleTabSelection(){
      setState(() {
        widget.colorVal=0xffff5722;
      });
    }
    _tabController= new TabController(vsync: this, length:2);
    _tabController.addListener(_handleTabSelection);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            indicatorWeight: 4.0,
            indicatorColor:Color(0xffff5722),
            unselectedLabelColor: Colors.grey,
            tabs: <Widget>[
              Tab(
                icon:Icon(Icons.compare, color: _tabController.index == 0
                    ? Color( widget.colorVal)
                    : Colors.grey),
                child:Text('For You',style: TextStyle( color: _tabController.index == 0
                    ?  Color( widget.colorVal)
                    : Colors.grey)),
              ),
              Tab(
                icon: Icon(Icons.compare, color: _tabController.index == 1
                    ? Color( widget.colorVal)
                    : Colors.grey),
                child: Text('Top Charts',style: TextStyle( color: _tabController.index == 1
                    ?  Color( widget.colorVal)
                    : Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    ) ;
  }



}