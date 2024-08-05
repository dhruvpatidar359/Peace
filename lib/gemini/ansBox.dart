import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:typewritertext/typewritertext.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:watch_it/watch_it.dart';

import '../models/AppState.dart';

class AnsBoxGemini extends WatchingStatefulWidget {
  AnsBoxGemini({required this.text});

  final text;

  @override
  State<AnsBoxGemini> createState() => _AnsBoxGeminiState();
}

class _AnsBoxGeminiState extends State<AnsBoxGemini> {
  @override
  Widget build(BuildContext context) {
    print(widget.text);
    return GestureDetector(
        onTap: () {
          GetIt.instance<AppState>().setGeminiAnswering = false;
          GetIt.instance<AppState>().setPrompt = "";
        },
        child: Container(
          width: MediaQuery.of(context).size.width / 1.5,
          padding: EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: const Color(0x36454F).withOpacity(0.5),
            border: Border.all(color: Colors.white70),
            borderRadius: BorderRadius.all(Radius.circular(40.0)),
          ),
          child: watchPropertyValue((AppState rv) {
            if (rv.prompt == "") {
              return Center(
                  child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 25,
                      child: CircularProgressIndicator(
                          strokeWidth: 2,
                          strokeCap: StrokeCap.round,
                          color: Colors.white)));
            } else {
              return Container(
                height: 500,
                child: Markdown(
                  physics: BouncingScrollPhysics(),
                  data: widget.text.toString(),
                  extensionSet: md.ExtensionSet(
                    md.ExtensionSet.gitHubFlavored.blockSyntaxes,
                    <md.InlineSyntax>[
                      md.EmojiSyntax(),
                      ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes
                    ],
                  ),
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                          listBullet: TextStyle(color: Colors.white),
                          p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontSize: 12.0,
                              color: Colors.white,
                              fontStyle:
                                  GoogleFonts.poppins(color: Colors.white)
                                      .fontStyle)),
                ),
              );
            }
          }),
        ));
  }
}
