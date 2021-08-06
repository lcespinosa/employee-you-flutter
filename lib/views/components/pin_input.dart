import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PinInput extends StatefulWidget {

  final pinController;
  final bottomRight;
  final topRight;

  PinInput(this.pinController, this.bottomRight, this.topRight);

  @override
  _PinInputState createState() => _PinInputState();
}

class _PinInputState extends State<PinInput> {
  bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 40, bottom: 30),
      child: Container(
        width: MediaQuery.of(context).size.width - 40,
        child: Material(
          elevation: 10,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(widget.bottomRight),
                  topLeft: Radius.circular(widget.topRight))),
          child: Padding(
            padding: EdgeInsets.only(left: 40, right: 85, top: 10, bottom: 10),
            child: TextFormField(
              style: TextStyle(fontSize: 24),
              obscureText: !_showPassword,
              controller: widget.pinController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.security, size: 24, color: Colors.grey,),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.remove_red_eye,
                      color: this._showPassword ? Colors.blue : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() => this._showPassword = !this._showPassword);
                    },
                  ),
                  hintText: "12345",
                  hintStyle: TextStyle(color: Color(0xFFE1E1E1), fontSize: 14)),
            ),
          ),
        ),
      ),
    );
  }
}