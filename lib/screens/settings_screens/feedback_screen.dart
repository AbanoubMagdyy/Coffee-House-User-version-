import 'package:coffee_house/components/components.dart';
import 'package:coffee_house/components/constants.dart';
import 'package:coffee_house/shared/profile_bloc/states.dart';
import 'package:coffee_house/style/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../models/filter_chip_model.dart';
import '../../models/rating_model.dart';
import '../../shared/profile_bloc/cubit.dart';
import '../../widgets/filter_chip_widget.dart';

class FeedbackScreen extends StatefulWidget {
  final RatingModel model;

  const FeedbackScreen({Key? key, required this.model}) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  List<FilterChipModel> filterChaps = [];

  final feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    filterChaps = [
      FilterChipModel(
          name: 'Clean',
          value: false,
          list: ProfileCubit.get(context).goodThings),
      FilterChipModel(
          name: 'Good package',
          value: false,
          list: ProfileCubit.get(context).goodThings),
      FilterChipModel(
          name: 'Pair price',
          value: false,
          list: ProfileCubit.get(context).goodThings),
      FilterChipModel(
          name: 'Good drinks',
          value: false,
          list: ProfileCubit.get(context).goodThings),
      FilterChipModel(
          name: 'Good staff',
          value: false,
          list: ProfileCubit.get(context).goodThings),
    ];
    if (widget.model.name.isNotEmpty) {
      userRating(context);
    }
    return BlocConsumer<ProfileCubit, ProfileStates>(
      listener: (context, state) {
        if (state is SuccessSentUserRating) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        var cubit = ProfileCubit.get(context);
        return Scaffold(
          appBar: defAppBar(context, 'Feedback'),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        if (state is LoadingSentUserRating)
                          defLinearProgressIndicator(),

                        /// logo
                        const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                AssetImage('assets/images/logo.png')),

                        /// app name
                        defText(text: appName),

                        /// rating
                        RatingBar.builder(
                          initialRating: cubit.valueOfRate.toDouble(),
                          minRating: 1,
                          itemCount: 5,
                          itemPadding: const EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 8),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          onRatingUpdate: (rating) {
                            cubit.rateTextMethod(rating.toInt());
                          },
                        ),

                        /// rate text
                        defText(text: cubit.ratingText),

                        /// chips
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          child: Wrap(
                            spacing: 8,
                            children: [
                              for (var widget in filterChaps)
                                FilterChipWidget(
                                  name: widget.name,
                                  list: widget.list,
                                  isSelected: widget.value,
                                ),
                            ],
                          ),
                        ),

                        /// text field
                        Container(
                          decoration: BoxDecoration(
                            color: secColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: TextFormField(
                            controller: feedbackController,
                            minLines: 5,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            style: const TextStyle(color: defColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  'Do you have something to share with $appName?\nLeave a review now!\nYour rating and comments will be displayed anonymously.',
                              hintStyle: TextStyle(
                                color: defColor.withOpacity(0.5),

                              ),
                              contentPadding: const EdgeInsets.all(10.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      /// previous
                      if (widget.model.name.isNotEmpty)
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {});
                            },
                            child: Container(
                              height: 50,
                              margin: const EdgeInsets.only(
                                right: 10,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadiusDirectional.circular(30),
                                border: Border.all(
                                  color: secColor,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child:
                                    FittedBox(child: defText(text: 'Previous',),),
                              ),
                            ),
                          ),
                        ),

                      /// submit
                      Expanded(
                        child: defButton(
                          onTap: () => cubit.sentUserRating(
                              comment: feedbackController.text),
                          child: defText(
                            text: 'Submit',
                            textColor: defColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  void formatFilterChapsList() {
    for (var item in filterChaps) {
      if (widget.model.goodThings.contains(item.name)) {
        item.value = true;
      } else {
        item.value = false;
      }
    }
  }

  void userRating(context) {
    feedbackController.text = widget.model.comment;
    ProfileCubit.get(context).valueOfRate = widget.model.rate;
    formatFilterChapsList();
  }
}
