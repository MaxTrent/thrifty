import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:thrifty/data/data.dart';

// import 'package:flutter/services.dart';
import '../models/models.dart';
import '../widgets/widgets.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with TickerProviderStateMixin {
  DatabaseService service = DatabaseService();
  String totalAmt = '₦ 0.0',
      budgetAmt = '₦ 0.0',
      dailyAmt = '₦ 0.0',
      weeklyAmt = '₦ 0.0',
      amtSpent = '₦ 0.0',
      totalAmountSpentFormatted = '₦ 0.0';
  final bool _imageLoaded = false;
  late List budgetsList;
  late List retrievedBudgetList;
  late List transactionsCreditList;
  late List retrievedTransactionsCreditList;
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    getAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: RefreshIndicator(
            color: Theme.of(context).colorScheme.secondary,
            onRefresh: () {
              return getAllData();
            },
            child: SafeArea(
              child: ListView(
                // controller: _controller,
                children: [
                  Column(
                    children: [
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(25.0, 0, 8.0, 0),
                              child: _imageLoaded
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/userpage');
                                      },
                                      child: CircleAvatar(
                                        radius: 40.0,
                                        foregroundColor:
                                            Color.fromARGB(255, 223, 220, 220),
                                        child: CachedNetworkImage(
                                          // imageUrl: user!.photoURL.toString(),
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            width: 80.0,
                                            height: 80.0,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    )
                                  : InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/userpage');
                                      },
                                      child: const CircleAvatar(
                                        radius: 40.0,
                                        foregroundColor:
                                            Color.fromARGB(255, 223, 220, 220),
                                        backgroundImage:
                                            AssetImage('images/profile.png'),
                                      ),
                                    )),
                          const SizedBox(
                            width: 50.0,
                          ),
                          const Text(
                            'Dashboard',
                            style: TextStyle(
                              letterSpacing: 0.5,
                              fontSize: 22.0,
                              fontWeight: FontWeight.w900,
                              color: Color.fromARGB(255, 35, 63, 105),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 8.0,
                      ),
                      Padding(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 1.0),
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 35, 63, 105),
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      25.0, 15.0, 25.0, 15.0),
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 45.0,
                                      ),
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: Text('Sapa',
                                            // totalAmt,
                                            style: const TextStyle(
                                                letterSpacing: 0.5,
                                                fontSize: 27.0,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white)),
                                      ),
                                      const SizedBox(
                                        height: 45.0,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.blue,
                                                minimumSize: const Size(50, 45),
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15.0)),
                                                textStyle: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    letterSpacing: 0.5,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            onPressed: () {
                                              showModalBottomSheet<void>(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  enableDrag: false,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                      top:
                                                          Radius.circular(35.0),
                                                    ),
                                                  ),
                                                  builder: (BuildContext
                                                          context) =>
                                                      StatefulBuilder(builder:
                                                          (context,
                                                              setModalState) {
                                                        return Padding(
                                                            padding: EdgeInsets.only(
                                                                bottom: MediaQuery.of(
                                                                        context)
                                                                    .viewInsets
                                                                    .bottom),
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .all(
                                                                      25.0),
                                                              child: Form(
                                                                // key: _formKey,
                                                                child: ListView(
                                                                    shrinkWrap:
                                                                        true,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          const Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              'Amount',
                                                                              style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 0.2, fontSize: 16.0, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 67, 65, 65)),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.0,
                                                                          ),
                                                                          Theme(
                                                                            data:
                                                                                Theme.of(context).copyWith(
                                                                              colorScheme: ThemeData().colorScheme.copyWith(primary: Color.fromARGB(255, 44, 79, 106)),
                                                                            ),
                                                                            child:
                                                                                TextFormField(
                                                                              // inputFormatters: [
                                                                              //   CurrencyTextInputFormatter(
                                                                              //     locale: 'en_NG',
                                                                              //     decimalDigits: 0,
                                                                              //     symbol: '₦',
                                                                              //   ),
                                                                              //   LengthLimitingTextInputFormatter(21),
                                                                              // ],
                                                                              // controller: _amountController,
                                                                              decoration: const InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: '12,000.00',
                                                                              ),
                                                                              keyboardType: TextInputType.number,
                                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                              onFieldSubmitted: (value) {},
                                                                              validator: (value) {
                                                                                if (value!.trim().isEmpty) {
                                                                                  return 'Amount is required';
                                                                                } else if (value.replaceAll('₦', '') == '0') {
                                                                                  return 'Amount can not be 0';
                                                                                }
                                                                              },
                                                                            ),
                                                                          ),
                                                                          const SizedBox(
                                                                            height:
                                                                                40.0,
                                                                          ),
                                                                          const Align(
                                                                            alignment:
                                                                                Alignment.centerLeft,
                                                                            child:
                                                                                Text(
                                                                              'Description',
                                                                              style: TextStyle(fontFamily: 'OpenSans', letterSpacing: 0.2, fontSize: 16.0, fontWeight: FontWeight.w600, color: Color.fromARGB(255, 67, 65, 65)),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10.0,
                                                                          ),
                                                                          Theme(
                                                                            data:
                                                                                Theme.of(context).copyWith(
                                                                              colorScheme: ThemeData().colorScheme.copyWith(primary: Color.fromARGB(255, 44, 79, 106)),
                                                                            ),
                                                                            child:
                                                                                TextFormField(
                                                                              // controller: _amountDescriptionController,
                                                                              maxLength: 15,
                                                                              // inputFormatters: <TextInputFormatter>[
                                                                              //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                                                              //   LengthLimitingTextInputFormatter(100),
                                                                              // ],
                                                                              decoration: const InputDecoration(
                                                                                border: OutlineInputBorder(),
                                                                                hintText: 'Bonus Amount',
                                                                              ),
                                                                              keyboardType: TextInputType.text,
                                                                              textCapitalization: TextCapitalization.sentences,
                                                                              autovalidateMode: AutovalidateMode.onUserInteraction,
                                                                              onFieldSubmitted: (value) {},
                                                                              validator: (value) {
                                                                                if (value!.trim().isEmpty) {
                                                                                  return 'Description is required';
                                                                                } else if (value.startsWith(RegExp(r'[0-9]'))) {
                                                                                  return 'Description is not valid';
                                                                                }
                                                                              },
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                40.0,
                                                                          ),
                                                                          ElevatedButton(
                                                                              style: ElevatedButton.styleFrom(
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(10),
                                                                                  ),
                                                                                  primary: Color.fromARGB(255, 4, 44, 76),
                                                                                  minimumSize: const Size.fromHeight(60),
                                                                                  textStyle: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                                                                              onPressed: () {},
                                                                              // !_loading
                                                                              //     ? () {
                                                                              //         if (_formKey.currentState!.validate()) {
                                                                              //           setState(() {
                                                                              //             _loading = true;
                                                                              //           });
                                                                              //           setModalState(() {
                                                                              //             _loading = true;
                                                                              //           });
                                                                              //
                                                                              //           String amount = _amountController.text.toString().replaceAll(',', '').replaceAll('₦', '').trim();
                                                                              //           String description = _amountDescriptionController.text.toString().trim();
                                                                              //
                                                                              //           addAmount(double.parse(amount), description, setModalState);
                                                                              //         }
                                                                              //       }
                                                                              //     : null,
                                                                              child: Text('Add Money')),
                                                                          SizedBox(
                                                                            height:
                                                                                30.0,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ));
                                                      }));
                                            },
                                            child: const Text('+ Add Money')),
                                      ),
                                      const SizedBox(
                                        height: 30.0,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text('omo',
                                            // '${DateFormat('yMMMMd').format(DateTime.now())}',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                letterSpacing: 0.5,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)),
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                            ],
                          )),
                      SizedBox(
                        width: 350.0,
                        child: TabBar(
                          // controller: tabController,
                          tabs: const [
                            Tab(text: 'Expenses'),
                            Tab(
                              text: 'Income',
                            )
                          ],
                          indicator: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: const Color.fromARGB(255, 35, 63, 105)),
                          unselectedLabelColor: Colors.grey[700],
                          labelColor: Colors.white,
                          labelStyle: const TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 500,
                        height: 500,
                        child: TabBarView(
                          // controller: tabController,
                          children: [
                            Column(children: [
                              Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      30.0, 0.0, 30.0, 0.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary:
                                            const Color.fromARGB(255, 1, 8, 14),
                                        textStyle: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      onPressed: () {},
                                      // () {
                                      //   Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             const AddBudget()),
                                      //   ).then((_) {
                                      //     setState(() {
                                      //       getAllData();
                                      //     });
                                      //   });
                                      // },
                                      child: const Text('+ Add Budget'),
                                    ),
                                  )),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(15.0, 0, 15.0, 0),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  height: 400.0,
                                  child: FutureBuilder(
                                      // future: budgetsList,
                                      builder: (BuildContext context,
                                          AsyncSnapshot<List<Budgets>>
                                              snapshot) {
                                    if (snapshot.connectionState ==
                                            ConnectionState.done &&
                                        retrievedBudgetList?.isEmpty == null) {
                                      const Center(
                                        child: Text(
                                          'No Budgets Yet',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20.0),
                                        ),
                                      );
                                    }
                                    if (retrievedBudgetList?.isEmpty ?? true) {
                                      return const Center(
                                        child: Text(
                                          'No Budgets Yet',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 20.0),
                                        ),
                                      );
                                    }
                                    if (snapshot.hasData &&
                                        snapshot.data != null) {
                                      return Center(
                                        child: ListView.separated(
                                          shrinkWrap: true,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(height: 15);
                                          },
                                          primary: false,
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              retrievedBudgetList?.length ?? 0,
                                          itemBuilder: _itemBuilder,
                                        ),
                                      );
                                    } else {
                                      return const Center(
                                        child: LoadingIndicator(),
                                      );
                                    }
                                  }),
                                ),
                              )
                            ]),
                            Column(
                              children: [
                                SizedBox(
                                  height: 5.0,
                                ),
                                Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        30.0, 0.0, 30.0, 0.0),
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 1, 8, 14),
                                          textStyle: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        onPressed: () {},
                                        //     () {
                                        //   Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(
                                        //         builder: (context) =>
                                        //             const FinancesPage()),
                                        //   ).then((_) {
                                        //     setState(() {
                                        //       // getAllData();
                                        //     });
                                        //   });
                                        // },
                                        child: const Text('View All'),
                                      ),
                                    )),
                                Container(
                                  height: 350.0,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        15.0, 0, 15.0, 0),
                                    child: FutureBuilder(
                                        // future: transactionsCreditList,
                                        builder: (BuildContext context,
                                            AsyncSnapshot<List<Transactions>>
                                                snapshot) {
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          retrievedTransactionsCreditList
                                                  ?.isEmpty ==
                                              null) {
                                        const Center(
                                          child: Text(
                                            'No Transactions Yet',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20.0),
                                          ),
                                        );
                                      }
                                      if (retrievedTransactionsCreditList
                                              ?.isEmpty ??
                                          true) {
                                        return const Center(
                                          child: Text(
                                            'No Transactions Yet',
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 20.0),
                                          ),
                                        );
                                      }
                                      if (snapshot.hasData &&
                                          snapshot.data != null) {
                                        return ListView.separated(
                                          shrinkWrap: true,
                                          separatorBuilder:
                                              (BuildContext context,
                                                  int index) {
                                            return const SizedBox(height: 15);
                                          },
                                          primary: false,
                                          scrollDirection: Axis.vertical,
                                          itemCount:
                                              retrievedTransactionsCreditList
                                                      ?.length ??
                                                  0,
                                          itemBuilder: _transactionItemBuilder,
                                        );
                                      } else {
                                        return const Center(
                                            child: LoadingIndicator());
                                      }
                                    }),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const Center(child: LoadingIndicator())
      ],
    );
  }

  Widget _transactionItemBuilder(BuildContext context, int index) {
    var transactionAmt = NumberFormat.currency(locale: "en_NG", symbol: "₦")
        .format(double.parse(
            retrievedTransactionsCreditList![index].transactionAmount));

    String transactionName =
        retrievedTransactionsCreditList![index].transactionTitle;
    String imageText = '';

    var names = transactionName.split(' ');
    if (names.length >= 2) {
      imageText = (names[0][0] + names[1][0]).toUpperCase();
    } else {
      imageText =
          (names[0][0] + names[0][(transactionName.length - 1)]).toUpperCase();
    }
    String formattedTransacDate = DateFormat.yMMMd()
        .format(retrievedTransactionsCreditList![index].transactionDate);

    String formattedTransacTime = DateFormat.Hm()
        .format(retrievedTransactionsCreditList![index].transactionDate);

    bool isSameDate = true;
    final DateTime presentDate =
        retrievedTransactionsCreditList![index].transactionDate;

    if (service.daysBetween(
            retrievedTransactionsCreditList![index].transactionDate,
            DateTime.now()) ==
        0) {
      formattedTransacDate = 'Today';
    } else if (service.daysBetween(
            retrievedTransactionsCreditList![index].transactionDate,
            DateTime.now()) ==
        1) {
      formattedTransacDate = 'Yesterday';
    }

    if (index == 0) {
      isSameDate = false;
    } else {
      final DateTime prevDate =
          retrievedTransactionsCreditList![index - 1].transactionDate;
      final DateTime presentDate =
          retrievedTransactionsCreditList![index].transactionDate;
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
          Container(
            height: 65.0,
            decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 223, 220, 220),
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
                  SizedBox(
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
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8.0,
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                retrievedTransactionsCreditList![index]
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
                              '+  $transactionAmt',
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
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
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Container();
  }

  CachedNetworkImage(
      {required Container Function(dynamic context, dynamic imageProvider)
          imageBuilder,
      required CircularProgressIndicator Function(dynamic context, dynamic url)
          placeholder,
      required Icon Function(dynamic context, dynamic url, dynamic error)
          errorWidget}) {}
}

Future<void> getAllData() async {
  // return ;
}
