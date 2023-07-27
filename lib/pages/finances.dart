import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thrifty/models/models.dart';
import 'package:thrifty/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:thrifty/data/data.dart';

class FinancesPage extends StatefulWidget {
  const FinancesPage({Key? key}) : super(key: key);

  @override
  State<FinancesPage> createState() => _FinancesPageState();
}

class _FinancesPageState extends State<FinancesPage> {
  ScrollController? _controller;
  FirebaseAuth auth = FirebaseAuth.instance;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();
  final _transactionTypeController = TextEditingController();
  final _searchTextController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var startDate, minimumEndDate, endDate;
  DatabaseService service = DatabaseService();
  Future<List<Transactions>>? transactionsList;
  List<Transactions>? retrievedTransactionsList;
  bool isFilterDate = false, isFilterName = true, _loading = false;

  @override
  void initState() {
    super.initState();
    getAllData();
  }

  Future<void> getAllData() async {
    setState(() {
      _loading = true;
    });
    _initRetrieval();
  }

  Future<void> _initRetrieval() async {
    try {
      // setState(() {
      //   _loading = true;
      // });

      transactionsList = service.retrieveAllTransactions();
      retrievedTransactionsList = await service.retrieveAllTransactions();

      retrievedTransactionsList!.sort(
            (a, b) {
          return b.transactionDate.compareTo(a.transactionDate);
        },
      );
      setState(() {
        _loading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error in retrieving transactions: $e');
        errorDialog('Error in retrieving transactions', true);
      }
      setState(() {
        _loading = false;
      });
    }
  }


  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    _searchTextController.dispose();
    _transactionTypeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
            appBar: AppBar(
              leading: BackButton(color: Theme.of(context).colorScheme.primary),
              // backgroundColor: const Color.fromARGB(255, 242, 240, 240),
              title: Text(
                'Transactions',
                style: Theme.of(context)
                    .textTheme
                    .headline1!
                    .copyWith(color: Theme.of(context).colorScheme.primary),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.filter_list_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  onPressed: () {
                    _showPopupMenu();
                  },
                )
              ],
              centerTitle: true,
              elevation: 0,
            ),
            body: RefreshIndicator(
              onRefresh: () {
                return getAllData();
              },
              child: SafeArea(
                  child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Visibility(
                      visible: isFilterName,
                      child: Container(
                        height: 40.0,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(20.0)),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(40.0, 0, 40.0, 0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: TextFormField(
                                      controller: _searchTextController,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(20),
                                      ],
                                      onChanged: (value) =>
                                          filterTransaction(value),
                                      decoration: const InputDecoration(
                                        hintText: 'Foods & Drinks',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 18,
                                            fontWeight: FontWeight.w400),
                                      )),
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: ElevatedButton(
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        const Color.fromARGB(255, 35, 63, 105),
                                    minimumSize:
                                        const Size(80, double.infinity),
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15.0),
                                            bottomRight:
                                                Radius.circular(15.0))),
                                  ),
                                  child: const Icon(Icons.search_outlined)),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isFilterDate,
                      child: Row(
                        children: [
                          Expanded(
                              child: Column(
                            children: [
                              const Text('From',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 0.6,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w600,
                                      color: Color.fromARGB(255, 67, 65, 65))),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: _startDateController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'DD/MM/YYYY',
                                ),
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext builder) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height /
                                                3,
                                            child: CupertinoDatePicker(
                                              onDateTimeChanged:
                                                  (DateTime newdate) {
                                                var inputFormat =
                                                    DateFormat('dd/MM/yyyy');

                                                startDate = newdate;
                                                String startDateText =
                                                    inputFormat.format(newdate);

                                                _startDateController.value =
                                                    TextEditingValue(
                                                  text: startDateText,
                                                  selection: TextSelection
                                                      .fromPosition(
                                                    TextPosition(
                                                        offset: startDateText
                                                            .toString()
                                                            .length),
                                                  ),
                                                );
                                              },
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ));
                                      });
                                },
                              )
                            ],
                          )),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                              child: Column(
                            children: [
                              const Text(
                                'To',
                                style: TextStyle(
                                    fontFamily: 'OpenSans',
                                    letterSpacing: 0.6,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 67, 65, 65)),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: _endDateController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'DD/MM/YYYY',
                                ),
                                keyboardType: TextInputType.datetime,
                                readOnly: true,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext builder) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height /
                                                3,
                                            child: CupertinoDatePicker(
                                              minimumDate: startDate,
                                              initialDateTime: startDate,
                                              onDateTimeChanged:
                                                  (DateTime newdate) {
                                                var inputFormat =
                                                    DateFormat('dd/MM/yyyy');

                                                endDate = newdate;
                                                String endDateText =
                                                    inputFormat.format(newdate);

                                                _endDateController.value =
                                                    TextEditingValue(
                                                  text: endDateText,
                                                  selection: TextSelection
                                                      .fromPosition(
                                                    TextPosition(
                                                        offset: endDateText
                                                            .toString()
                                                            .length),
                                                  ),
                                                );
                                              },
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ));
                                      });
                                },
                              )
                            ],
                          )),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 25.0, 0, 0),
                            child: ElevatedButton(
                                onPressed: () {
                                  filterTransactionDate(startDate, endDate);
                                },
                                // style: Theme.of(context).elevatedButtonTheme.style,
                                child: const Icon(Icons.search_outlined)),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Expanded(
                      child: FutureBuilder(
                          future: transactionsList,
                          builder: (BuildContext context,
                              AsyncSnapshot<List<Transactions>> snapshot) {
                            if (snapshot.connectionState ==
                                    ConnectionState.done &&
                                retrievedTransactionsList?.isEmpty == null) {
                              return const Center(
                                child: Text(
                                  'No Transactions Yet',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20.0),
                                ),
                              );
                            }
                            if (retrievedTransactionsList?.isEmpty ?? true) {
                              return const Center(
                                child: Text(
                                  'No Transactions Yet',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20.0),
                                ),
                              );
                            }
                            if (snapshot.hasData && snapshot.data != null) {
                              return ListView.separated(
                                shrinkWrap: true,
                                separatorBuilder:
                                    (BuildContext context, int index) {
                                  return const SizedBox(height: 15);
                                },
                                primary: false,
                                scrollDirection: Axis.vertical,
                                itemCount:
                                    retrievedTransactionsList?.length ?? 0,
                                itemBuilder: _transactionItemBuilder,
                              );
                            } else {
                              return const Center(
                                child: LoadingIndicator(),
                              );
                            }
                          }),
                    ),
                  ],
                ),
              )),
            )),
        if (_loading)
          const Center(
            child: LoadingIndicator(),
          ),
      ],
    );
  }

  void _showPopupMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(500, 100, 10, 100),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      items: [
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showSortPopupMenu();
              },
              child: Row(
                children: [
                  Text(
                    "Sort By",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 25,
                  )
                ],
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _showSortPopupMenu() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(500, 100, 10, 100),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      items: [
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                setState(() {
                  isFilterDate = false;
                  isFilterName = true;
                });
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text(
                    "Name",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              )),
        ),
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                setState(() {
                  isFilterDate = true;
                  isFilterName = false;
                });
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  Text(
                    "Date",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              )),
        ),
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showTransactionType();
              },
              child: Row(
                children: [
                  Text(
                    "Transaction Type",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Theme.of(context).colorScheme.primary,
                    size: 25,
                  )
                ],
              )),
        ),
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                transactionModal();
              },
              child: Row(
                children: [
                  Text(
                    "Complex Search",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _showTransactionType() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(500, 100, 10, 100),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      items: [
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                setState(() {
                  isFilterName = false;
                  isFilterDate = false;
                });
                Navigator.pop(context);
                getCredit();
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.credit_score_outlined,
                    color: Color.fromARGB(255, 27, 94, 32),
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "Credits",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              )),
        ),
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                setState(() {
                  isFilterName = false;
                  isFilterDate = false;
                });
                Navigator.pop(context);
                getDebit();
              },
              child: Row(
                children: [
                  const Icon(Icons.credit_score_outlined,
                      color: Color.fromARGB(255, 183, 28, 28)),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "Debits",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  void _showTransactionType2() async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(
        500,
        800,
        10,
        10,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))),
      items: [
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _transactionTypeController.text = 'Credit';
                });
              },
              child: Row(
                children: const [
                  Icon(
                    Icons.credit_score_outlined,
                    color: Color.fromARGB(255, 27, 94, 32),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "Credit",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              )),
        ),
        PopupMenuItem(
          child: TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _transactionTypeController.text = 'Debit';
                });
              },
              child: Row(
                children: const [
                  Icon(Icons.credit_score_outlined,
                      color: Color.fromARGB(255, 183, 28, 28)),
                  SizedBox(
                    width: 8.0,
                  ),
                  Text(
                    "Debit",
                    style: TextStyle(color: Colors.black, fontSize: 15),
                  ),
                ],
              )),
        ),
      ],
      elevation: 8.0,
    );
  }

  Widget _transactionItemBuilder(BuildContext context, int index) {
    final transaction = retrievedTransactionsList![index].transactionTitle;
    var transactionAmt = NumberFormat.currency(locale: "en_NG", symbol: "₦")
        .format(
            double.parse(retrievedTransactionsList![index].transactionAmount));

    String transactionName = retrievedTransactionsList![index].transactionTitle;
    String imageText = '';

    var names = transactionName.split(' ');
    if (names.length >= 2) {
      imageText = (names[0][0] + names[1][0]).toUpperCase();
    } else {
      imageText =
          (names[0][0] + names[0][(transactionName.length - 1)]).toUpperCase();
    }
    String formattedTransacDate = DateFormat.yMMMd()
        .format(retrievedTransactionsList![index].transactionDate);

    String formattedTransacTime = DateFormat.Hm()
        .format(retrievedTransactionsList![index].transactionDate);

    var amtColor;
    String amtSign;
    bool isSameDate = true;
    final DateTime presentDate =
        retrievedTransactionsList![index].transactionDate;

    if (retrievedTransactionsList![index].transactionType == 'Credit') {
      amtColor = Colors.green[900];
      amtSign = '+';
    } else {
      amtColor = Colors.red[900];
      amtSign = '-';
    }

    if (service.daysBetween(retrievedTransactionsList![index].transactionDate,
            DateTime.now()) ==
        0) {
      formattedTransacDate = 'Today';
    } else if (service.daysBetween(
            retrievedTransactionsList![index].transactionDate,
            DateTime.now()) ==
        1) {
      formattedTransacDate = 'Yesterday';
    }

    if (index == 0) {
      isSameDate = false;
    } else {
      final DateTime prevDate =
          retrievedTransactionsList![index - 1].transactionDate;
      final DateTime presentDate =
          retrievedTransactionsList![index].transactionDate;
      isSameDate = service.isSameDate(presentDate, prevDate);
    }

    if (index == 0 || !(isSameDate)) {
      isSameDate = false;
    }

    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          Visibility(
              visible: !isSameDate,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    formattedTransacDate,
                    style: TextStyle(
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 16.0),
                  ),
                ),
              )),
          Dismissible(
            direction: DismissDirection.endToStart,
            key: UniqueKey(),
            onDismissed: (direction) {
              deleteTransaction(retrievedTransactionsList![index]
                  .transactionTitle
                  .toLowerCase());
              setState(() {
                retrievedTransactionsList!.removeAt(index);
              });
            },
            background: Container(
              color: Colors.red[800],
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Delete Transaction',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0),
                  ),
                ),
              ),
            ),
            child: Container(
              height: 65.0,
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color.fromARGB(255, 223, 220, 220),
                  ),
                  borderRadius: BorderRadius.circular(15.0)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 0, 15.0, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      minRadius: 25.0,
                      child: Text(imageText),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                transactionName,
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  retrievedTransactionsList![index]
                                      .transactionDescription,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[700],
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$amtSign  $transactionAmt',
                                style: TextStyle(
                                    color: amtColor,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8.0,
                              ),
                              Text(
                                formattedTransacTime,
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    fontWeight: FontWeight.w500),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> filterTransaction(String enteredKeyword) async {
    retrievedTransactionsList = await service.retrieveAllTransactions();
    List<Transactions> results = [];
    if (enteredKeyword.isEmpty) {
      results = await service.retrieveAllTransactions();
    } else {
      results = retrievedTransactionsList!
          .where((transaction) => transaction.transactionTitle
              .toLowerCase()
              .contains(enteredKeyword.toLowerCase()))
          .toList();
      results.sort(
        (a, b) {
          return b.transactionDate.compareTo(a.transactionDate);
        },
      );
    }

    // Refresh the UI
    setState(() {
      retrievedTransactionsList = results;
    });
  }

  Future<void> getCredit() async {
    Future<List<Transactions>>? transactionsCreditList;
    List<Transactions>? retrievedTransactionsCreditList;

    setState(() {
      _loading = true;
    });

    transactionsCreditList = service.retrieveTransactionsCredit();
    retrievedTransactionsCreditList =
        await service.retrieveTransactionsCredit();

    retrievedTransactionsCreditList.sort(
      (a, b) {
        return b.transactionDate.compareTo(a.transactionDate);
      },
    );

    setState(() {
      transactionsList = transactionsCreditList;
      retrievedTransactionsList = retrievedTransactionsCreditList;

      _loading = false;
    });
  }

  Future<void> getDebit() async {
    Future<List<Transactions>>? transactionsDebitList;
    List<Transactions>? retrievedTransactionsDebitList;

    setState(() {
      _loading = true;
    });

    transactionsDebitList = service.retrieveTransactionsDebit();
    retrievedTransactionsDebitList = await service.retrieveTransactionsDebit();

    retrievedTransactionsDebitList.sort(
      (a, b) {
        return b.transactionDate.compareTo(a.transactionDate);
      },
    );

    setState(() {
      transactionsList = transactionsDebitList;
      retrievedTransactionsList = retrievedTransactionsDebitList;
      _loading = false;
    });
  }

  Future<void> filterTransactionDate(DateTime from, DateTime to) async {
    retrievedTransactionsList = await service.retrieveAllTransactions();
    List<Transactions> results = [];
    if (from.toString().isEmpty || to.toString().isEmpty) {
      results = await service.retrieveAllTransactions();
    } else {
      results = retrievedTransactionsList!
          .where((transaction) =>
              transaction.transactionDate.isAfter(from) &&
              transaction.transactionDate.isBefore(to))
          .toList();
      results.sort(
        (a, b) {
          return b.transactionDate.compareTo(a.transactionDate);
        },
      );
    }

    // Refresh the UI
    setState(() {
      _startDateController.clear();
      _endDateController.clear();
      retrievedTransactionsList = results;
    });
  }

  Future<void> deleteTransaction(title) async {
    setState(() {
      _loading = true;
    });
    final User? user = auth.currentUser;

    await FirebaseFirestore.instance
        .collection("expenses")
        .doc("transactions")
        .collection(user!.email.toString())
        .where('LowerCaseTrasactionTitle', isEqualTo: title)
        .get()
        .then((value) => value.docs.forEach((doc) {
              doc.reference.delete().then((value) {
                errorDialog('Transaction Deleted Successfully', false);
              }, onError: (e) {
                errorDialog(e.toString(), true);
              });
            }));

    setState(() {
      _loading = false;
    });
  }

  void errorDialog(String errorMessage, bool isError) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? Colors.red[600] : Colors.green[600],
        elevation: 0,
        content: Text(
          errorMessage,
          style: Theme.of(context).textTheme.headline3!.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        )));
  }

  Future<void> filterComplexTransaction(
      DateTime from, DateTime to, String transactionType) async {
    setState(() {
      _loading = true;
    });
    retrievedTransactionsList = await service.retrieveAllTransactions();
    List<Transactions> results = [];
    if (from.toString().isEmpty || to.toString().isEmpty) {
      results = await service.retrieveAllTransactions();
    } else {
      results = retrievedTransactionsList!
          .where((transaction) =>
              transaction.transactionDate.isAfter(from) &&
              transaction.transactionDate.isBefore(to) &&
              transaction.transactionType.contains(transactionType))
          .toList();
      results.sort(
        (a, b) {
          return b.transactionDate.compareTo(a.transactionDate);
        },
      );
    }

    // Refresh the UI
    setState(() {
      _loading = false;
      _startDateController.clear();
      _endDateController.clear();
      _transactionTypeController.clear();
      retrievedTransactionsList = results;
    });
  }

  Future<void> transactionModal() {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(35.0),
          ),
        ),
        builder: (BuildContext context) =>
            StatefulBuilder(builder: (context, setModalState) {
              return Form(
                key: _formKey,
                child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Container(
                      padding: const EdgeInsets.all(25.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Date :',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                  child: TextFormField(
                                controller: _startDateController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Start Date',
                                    suffixIcon: Icon(Icons.arrow_drop_down)),
                                keyboardType: TextInputType.datetime,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'Start Date is required';
                                  }
                                },
                                readOnly: true,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext builder) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height /
                                                3,
                                            child: CupertinoDatePicker(
                                              onDateTimeChanged:
                                                  (DateTime newdate) {
                                                var inputFormat =
                                                    DateFormat('dd/MM/yyyy');

                                                startDate = newdate;
                                                String startDateText =
                                                    inputFormat.format(newdate);

                                                _startDateController.value =
                                                    TextEditingValue(
                                                  text: startDateText,
                                                  selection: TextSelection
                                                      .fromPosition(
                                                    TextPosition(
                                                        offset: startDateText
                                                            .toString()
                                                            .length),
                                                  ),
                                                );
                                              },
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ));
                                      });
                                },
                              )),
                              const SizedBox(
                                width: 15.0,
                              ),
                              Expanded(
                                  child: TextFormField(
                                controller: _endDateController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'End Date',
                                    suffixIcon: Icon(Icons.arrow_drop_down)),
                                keyboardType: TextInputType.datetime,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'End Date is required';
                                  }
                                },
                                readOnly: true,
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext builder) {
                                        return Container(
                                            height: MediaQuery.of(context)
                                                    .copyWith()
                                                    .size
                                                    .height /
                                                3,
                                            child: CupertinoDatePicker(
                                              minimumDate: startDate,
                                              initialDateTime: startDate,
                                              onDateTimeChanged:
                                                  (DateTime newdate) {
                                                var inputFormat =
                                                    DateFormat('dd/MM/yyyy');

                                                endDate = newdate;
                                                String endDateText =
                                                    inputFormat.format(newdate);

                                                _endDateController.value =
                                                    TextEditingValue(
                                                  text: endDateText,
                                                  selection: TextSelection
                                                      .fromPosition(
                                                    TextPosition(
                                                        offset: endDateText
                                                            .toString()
                                                            .length),
                                                  ),
                                                );
                                              },
                                              mode:
                                                  CupertinoDatePickerMode.date,
                                            ));
                                      });
                                },
                              )),
                            ],
                          ),
                          const SizedBox(
                            height: 40.0,
                          ),
                          Row(
                            children: [
                              const Text(
                                'Transaction Type :',
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                width: 20.0,
                              ),
                              Expanded(
                                  child: TextFormField(
                                controller: _transactionTypeController,
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'Select Type',
                                    suffixIcon: Icon(Icons.arrow_drop_down)),
                                keyboardType: TextInputType.datetime,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onFieldSubmitted: (value) {},
                                validator: (value) {
                                  if (value!.trim().isEmpty) {
                                    return 'Transaction type is required';
                                  }
                                },
                                readOnly: true,
                                onTap: () {
                                  _showTransactionType2();
                                },
                              ))
                            ],
                          ),
                          const SizedBox(
                            height: 60.0,
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  primary:
                                      const Color.fromARGB(255, 35, 63, 105),
                                  minimumSize: const Size.fromHeight(60),
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              onPressed: !_loading
                                  ? () {
                                      if (_formKey.currentState!.validate()) {
                                        Navigator.pop(context);
                                        filterComplexTransaction(
                                            startDate,
                                            endDate,
                                            _transactionTypeController.text
                                                .toString());
                                      }
                                    }
                                  : null,
                              child: const Text('GO')),
                          const SizedBox(
                            height: 70.0,
                          )
                        ],
                      ),
                    )),
              );
            }));
  }
}
