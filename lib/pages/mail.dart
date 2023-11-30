import 'package:flutter/material.dart';
import 'package:relayered/functions.dart';

import '../data.dart';
import '../functions/mail.dart';
import '../widgets/body.dart';

class PageMail extends StatefulWidget {
  const PageMail({super.key});

  @override
  State<PageMail> createState() => _PageMailState();
}

class _PageMailState extends State<PageMail> {
  final TextEditingController _mailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    /*
	  String local = View.of(context).platformDispatcher.locale.languageCode;
	
    if (languages.keys.contains(local) && pf['firstBoot']) {
      pf['locale'] = local;
    }
	*/
    return FutureBuilder(
      future: loadLocale(),
      builder: (context, snap) {
        if (!snap.hasData) return Container();
        return Scaffold(
          appBar: AppBar(title: Text(t('Account'))),
          body: Body(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: AutofillGroup(
                  child: ListView(
                    children: [
                      const SizedBox(height: 16),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        autofocus: true,
                        autofillHints: const [AutofillHints.email],
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                        controller: _mailController,
                        decoration: InputDecoration(
                          labelText: l['Email'],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      TextFormField(
                        autofillHints: const [AutofillHints.password],
                        autofocus: true,
                        style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16),
                        controller: _passController,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          labelText: l['Password'],
                        ),
                      ),
                      const SizedBox(
                        height: 32,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              child: Card(
                                elevation: 6,
                                shadowColor: Theme.of(context).primaryColor,
                                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                                color: Theme.of(context).primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () async {
                                    FirebaseService service = FirebaseService();
                                    await service.signUpWithMail(
                                      _mailController.text.trim(),
                                      _passController.text,
                                      context,
                                    );
                                  },
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    height: 50,
                                    child: Center(
                                      child: Text(
                                        l['Sign up'],
                                        style: TextStyle(
                                          color: Theme.of(context).colorScheme.background,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              elevation: 6,
                              shadowColor: Theme.of(context).primaryColor,
                              margin: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 16,
                              ),
                              color: Theme.of(context).primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: InkWell(
                                onTap: () async {
                                  FirebaseService service = FirebaseService();
                                  await service.signInWithMail(
                                    _mailController.text.trim(),
                                    _passController.text,
                                    context,
                                  );
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  height: 50,
                                  child: Center(
                                    child: Text(
                                      l['Log in'],
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.background,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 32,
                          bottom: 8,
                          top: 16,
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            child: Text(
                              l['Reset password'],
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onPressed: () async {
                              FirebaseService service = FirebaseService();
                              service.resetPassword(_mailController.text.trim(), context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
