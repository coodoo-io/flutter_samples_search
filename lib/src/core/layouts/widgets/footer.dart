import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  const Footer({
    Key? key,
    required this.maxWidth,
  }) : super(key: key);

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 40.0,
      alignment: Alignment.center,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Text(
                  '@coodoo_io',
                  style: theme.textTheme.caption?.copyWith(fontSize: 11),
                ),
                onTap: () async => await launchUrl(
                  Uri(scheme: 'https', host: 'www.twitter.com', path: 'coodoo_io'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
              InkWell(
                child: Text(
                  'Imprint',
                  style: theme.textTheme.caption?.copyWith(fontSize: 11),
                ),
                onTap: () async => await launchUrl(
                  Uri(scheme: 'https', host: 'www.coodoo.de', path: 'impressum'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
