import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uangku/helpers/formatter.dart';
import 'package:uangku/models/database.dart';
import 'package:uangku/models/transaction_with_category.dart';
import 'package:uangku/pages/transaction_page.dart';

class HomePage extends StatefulWidget {
  final DateTime selectedDate;
  const HomePage({super.key, required this.selectedDate});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AppDatabase database = AppDatabase();
  final Formatter formatter = Formatter();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: StreamBuilder<TransactionWithSum>(
            stream: database.getTransactionByDateRepo(widget.selectedDate),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                if (snapshot.hasData && snapshot.data!.allTransaction!.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Total income and expanse
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(16)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: const Icon(
                                      Icons.download,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Income",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 12
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(
                                        "Rp. ${formatter.formatNumber(snapshot.data!.income!)}",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 14
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: const Icon(
                                      Icons.upload,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Expanse",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 12
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(
                                        "Rp. ${formatter.formatNumber(snapshot.data!.expanse!)}",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 14
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      // Text Transaction
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "Transaction",
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: snapshot.data!.allTransaction!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Card(
                                elevation: 10,
                                child: ListTile(
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () async {
                                          await database.deleteTransactionRepo(snapshot.data!.allTransaction![index].transaction.id);
                                          setState(() {});
                                        },
                                      ),
                                      const SizedBox(width: 10,),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: (){
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context) => TransactionPage(
                                                  transactionWithCategory: snapshot.data!.allTransaction![index]
                                              )
                                          ));
                                        },
                                      ),
                                    ],
                                  ),
                                  title: Text(
                                      "Rp. ${formatter.formatNumber(
                                          snapshot.data!.allTransaction![index].transaction.amount
                                      )}"
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 10,),
                                      Text(
                                          snapshot.data!.allTransaction![index].transaction.name,
                                          style: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500
                                          )
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(
                                        snapshot.data!.allTransaction![index].category.name,
                                        style: GoogleFonts.montserrat(
                                            color: snapshot.data!.allTransaction![index].category.type == 2 ? Colors.red : Colors.green
                                        ),
                                      ),
                                    ],
                                  ),
                                  leading: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: snapshot.data!.allTransaction![index].category.type == 1 ? const Icon(
                                      Icons.download,
                                      color: Colors.green,
                                    ) : const Icon(
                                      Icons.upload,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                      )
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.grey[800],
                              borderRadius: BorderRadius.circular(16)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: const Icon(
                                      Icons.download,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Income",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 12
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(
                                        "Rp. ${formatter.formatNumber(0)}",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 14
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8)
                                    ),
                                    child: const Icon(
                                      Icons.upload,
                                      color: Colors.red,
                                    ),
                                  ),
                                  const SizedBox(width: 15,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Expanse",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 12
                                        ),
                                      ),
                                      const SizedBox(height: 5,),
                                      Text(
                                        "Rp. ${formatter.formatNumber(0)}",
                                        style: GoogleFonts.montserrat(
                                            color: Colors.white, fontSize: 14
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      // Text Transaction
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          "Transaction",
                          style: GoogleFonts.montserrat(
                              fontSize: 16, fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      const Center(
                        child: Text("Data not found"),
                      )
                    ],
                  );

                }
              }
            }
        ),
      ),
    );
  }
}
