import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms/sms.dart';

class InviteContacts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InviteScreen(title: 'On Air');
  }
}

class InviteScreen extends StatefulWidget {
  InviteScreen({Key key, this.title}) : super(key: key);

  final String title;
  final String cancelLabel = 'Cancel';
  final String selectLabel = 'Select contacts';
  final Color floatingButtonColor = Colors.red;
  final IconData reloadIcon = Icons.refresh;
  final IconData fireIcon = Icons.done_outline;

  @override
  _InviteScreenState createState() => new _InviteScreenState(
        floatingButtonLabel: this.selectLabel,
        icon: this.fireIcon,
        floatingButtonColor: this.floatingButtonColor,
      );
}

class _InviteScreenState extends State<InviteScreen> {
  List<Contact> _contacts = new List<Contact>();
  List<CustomContact> _uiCustomContacts = List<CustomContact>();
  List<CustomContact> _allContacts = List<CustomContact>();
  bool _isLoading = false;
  bool _isSelectedContactsView = false;
  String floatingButtonLabel;
  Color floatingButtonColor;
  IconData icon;

  _InviteScreenState({
    this.floatingButtonLabel,
    this.icon,
    this.floatingButtonColor,
  });

  @override
  void initState() {
    super.initState();
    getContactsPermission().then((granted) {
      if (granted[PermissionGroup.contacts] == PermissionStatus.granted) {
        refreshContacts();
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text('Oops!'),
                content: const Text('Looks like permission to read contacts is not granted.'),
                actions: <Widget>[
                  FlatButton(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: (_isSelectedContactsView) ? 
        new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.send),
              onPressed: () {
                _sendSms();
              },
            )
          ]
        ) : new AppBar(title: new Text(widget.title)),
      body: !_isLoading
          ? Container(
              child: ListView.builder(
                itemCount: _uiCustomContacts?.length,
                itemBuilder: (BuildContext context, int index) {
                  CustomContact _contact = _uiCustomContacts[index];
                  var _phonesList = _contact.contact.phones.toList();

                  return _buildListTile(_contact, _phonesList);
                },
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: new FloatingActionButton.extended(
        backgroundColor: floatingButtonColor,
        onPressed: _onSubmit,
        icon: Icon(icon),
        label: Text(floatingButtonLabel),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _sendSms() {
    setState(() {
      _isLoading = true;
    });

    SmsSender sender = new SmsSender();
    for (CustomContact contact in _uiCustomContacts) {
      SmsMessage message = new SmsMessage(contact.contact.phones.elementAt(0).value, 'Hello flutter!');
      sender.sendSms(message);
      contact.isChecked = false;
    }

    setState(() {
      _isLoading = false;
      _uiCustomContacts = _allContacts;
      _isSelectedContactsView = false;
      _restateFloatingButton(
        widget.selectLabel,
        Icons.done_outline,
        Colors.red,
      );
    });
  }

  void _onSubmit() {
    setState(() {
      if (!_isSelectedContactsView) {
        _uiCustomContacts =
            _allContacts.where((contact) => contact.isChecked == true).toList();
        _isSelectedContactsView = true;
        _restateFloatingButton(
          widget.cancelLabel,
          Icons.refresh,
          Colors.green,
        );
      } else {
        _uiCustomContacts = _allContacts;
        _isSelectedContactsView = false;
        _restateFloatingButton(
          widget.selectLabel,
          Icons.done_outline,
          Colors.red,
        );
      }
    });
  }

  ListTile _buildListTile(CustomContact c, List<Item> list) {
    return ListTile(
      // leading: CircleAvatar(
      //         child: Text(
      //             (c.contact.displayName[0] +
      //                 c.contact.displayName[1].toUpperCase()),
      //             style: TextStyle(color: Colors.white)),
      //       ),
      title: Text(c.contact.displayName ?? ""),
      subtitle: list.length >= 1 && list[0]?.value != null
          ? Text(list[0].value)
          : Text(''),
      trailing: Checkbox(
          activeColor: Colors.green,
          value: c.isChecked,
          onChanged: (bool value) {
            setState(() {
              c.isChecked = value;
            });
          }),
    );
  }

  void _restateFloatingButton(String label, IconData icon, Color color) {
    floatingButtonLabel = label;
    this.icon = icon;
    floatingButtonColor = color;
  }

  refreshContacts() async {
    setState(() {
      _isLoading = true;
    });
    var contacts = await ContactsService.getContacts();
    _populateContacts(contacts);
  }

  void _populateContacts(Iterable<Contact> contacts) {
    _contacts = contacts.where((item) => item.displayName != null).toList();
    _contacts.sort((a, b) => a.displayName.compareTo(b.displayName));
    _allContacts =
        _contacts.map((contact) => CustomContact(contact: contact)).toList();
    setState(() {
      _uiCustomContacts = _allContacts;
      _isLoading = false;
    });
  }

  Future< Map<PermissionGroup, PermissionStatus> > getContactsPermission() =>
      PermissionHandler().requestPermissions([PermissionGroup.contacts]);
}

class CustomContact {
  final Contact contact;
  bool isChecked;

  CustomContact({
    this.contact,
    this.isChecked = false,
  });
}