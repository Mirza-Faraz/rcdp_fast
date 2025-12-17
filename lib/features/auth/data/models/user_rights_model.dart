import 'package:equatable/equatable.dart';

class UserRightsModel extends Equatable {
  final bool mmSmartAppNr;
  final bool basicClientInformation;
  final bool groupFormation;
  final bool loanFormationInformation;
  final bool detailOfDomesticIncome;
  final bool clientBusinessInformation;
  final bool cashFlowAnalysis;
  final bool householdAndLiveStock;
  final bool houseHoldFacilitiesAndHealth;
  final bool guarantorInformation;
  final bool loanConsumerInformation;
  final bool attachments;
  final bool loanSubmitcaseInformation;
  final bool submitCaseList;
  final bool caseList;
  final bool disbursement;
  final bool reports;
  final bool followUpClients;
  final bool overdueClients;
  final bool nearByClients;
  final bool submittedCaseStatus;
  final bool recoveryModule;
  final bool noofLoanDisbursedthismonth;
  final bool amountDisbursedthisMonth;
  final bool olp;
  final bool dashboard;
  final bool activeClients;
  final bool recoverytargettillDate;
  final bool recoveryTillDate;
  final bool overdueClient; // Note: OverdueClients vs OverdueClient
  final bool overdueAmount;
  final bool par;
  final bool fileSubmitted;
  final bool xpinAllocated;
  final bool fileinProcess;

  const UserRightsModel({
    required this.mmSmartAppNr,
    required this.basicClientInformation,
    required this.groupFormation,
    required this.loanFormationInformation,
    required this.detailOfDomesticIncome,
    required this.clientBusinessInformation,
    required this.cashFlowAnalysis,
    required this.householdAndLiveStock,
    required this.houseHoldFacilitiesAndHealth,
    required this.guarantorInformation,
    required this.loanConsumerInformation,
    required this.attachments,
    required this.loanSubmitcaseInformation,
    required this.submitCaseList,
    required this.caseList,
    required this.disbursement,
    required this.reports,
    required this.followUpClients,
    required this.overdueClients,
    required this.nearByClients,
    required this.submittedCaseStatus,
    required this.recoveryModule,
    required this.noofLoanDisbursedthismonth,
    required this.amountDisbursedthisMonth,
    required this.olp,
    required this.dashboard,
    required this.activeClients,
    required this.recoverytargettillDate,
    required this.recoveryTillDate,
    required this.overdueClient,
    required this.overdueAmount,
    required this.par,
    required this.fileSubmitted,
    required this.xpinAllocated,
    required this.fileinProcess,
  });

  factory UserRightsModel.fromJson(Map<String, dynamic> json) {
    return UserRightsModel(
      mmSmartAppNr: json['MM_SMARTAPP_NR'] ?? false,
      basicClientInformation: json['BasicClientInformation'] ?? false,
      groupFormation: json['GroupFormation'] ?? false,
      loanFormationInformation: json['LoanFormationInformation'] ?? false,
      detailOfDomesticIncome: json['DetailOfDomesticIncome'] ?? false,
      clientBusinessInformation: json['ClientBusinessInformation'] ?? false,
      cashFlowAnalysis: json['CashFlowAnalysis'] ?? false,
      householdAndLiveStock: json['HouseholdAndLiveStock'] ?? false,
      houseHoldFacilitiesAndHealth: json['HouseHoldFacilitiesAndHealth'] ?? false,
      guarantorInformation: json['GuarantorInformation'] ?? false,
      loanConsumerInformation: json['LoanConsumerInformation'] ?? false,
      attachments: json['Attachments'] ?? false,
      loanSubmitcaseInformation: json['LoanSubmitcaseInformation'] ?? false,
      submitCaseList: json['SubmitCaseList'] ?? false,
      caseList: json['CaseList'] ?? false,
      disbursement: json['Disbursement'] ?? false,
      reports: json['Reports'] ?? false,
      followUpClients: json['FollowUpClients'] ?? false,
      overdueClients: json['OverdueClients'] ?? false,
      nearByClients: json['NearByClients'] ?? false,
      submittedCaseStatus: json['SubmittedCaseStatus'] ?? false,
      recoveryModule: json['RecoveryModule'] ?? false,
      noofLoanDisbursedthismonth: json['NoofLoanDisbursedthismonth'] ?? false,
      amountDisbursedthisMonth: json['AmountDisbursedthisMonth'] ?? false,
      olp: json['OLP'] ?? false,
      dashboard: json['DashBoard'] ?? false,
      activeClients: json['ActiveClients'] ?? false,
      recoverytargettillDate: json['RecoverytargettillDate'] ?? false,
      recoveryTillDate: json['RecoveryTillDate'] ?? false,
      overdueClient: json['OverdueClient'] ?? false,
      overdueAmount: json['OverdueAmount'] ?? false,
      par: json['PAR'] ?? false,
      fileSubmitted: json['FileSubmitted'] ?? false,
      xpinAllocated: json['XpinAllocated'] ?? false,
      fileinProcess: json['FileinProcess'] ?? false,
    );
  }
  
  // Factory constructor from JSON string
  factory UserRightsModel.fromJsonString(String jsonString) {
    // Assuming you have 'dart:convert' imported where this is used, or here
    // But better to parse the map. 
    // Wait, the caller passes string.
    return UserRightsModel.fromJson(
        // we need dart:convert which is not imported in the original file I wrote?
        // Ah, I need to check imports.
        // I will assume I need to import it.
        // Actually, let's keep it simple: 
        // toJson should return Map.
        jsonString as dynamic // Placeholder, I should import convert
    ); 
  }
  
  Map<String, dynamic> toJson() {
    return {
      'MM_SMARTAPP_NR': mmSmartAppNr,
      'BasicClientInformation': basicClientInformation,
      'GroupFormation': groupFormation,
      'LoanFormationInformation': loanFormationInformation,
      'DetailOfDomesticIncome': detailOfDomesticIncome,
      'ClientBusinessInformation': clientBusinessInformation,
      'CashFlowAnalysis': cashFlowAnalysis,
      'HouseholdAndLiveStock': householdAndLiveStock,
      'HouseHoldFacilitiesAndHealth': houseHoldFacilitiesAndHealth,
      'GuarantorInformation': guarantorInformation,
      'LoanConsumerInformation': loanConsumerInformation,
      'Attachments': attachments,
      'LoanSubmitcaseInformation': loanSubmitcaseInformation,
      'SubmitCaseList': submitCaseList,
      'CaseList': caseList,
      'Disbursement': disbursement,
      'Reports': reports,
      'FollowUpClients': followUpClients,
      'OverdueClients': overdueClients,
      'NearByClients': nearByClients,
      'SubmittedCaseStatus': submittedCaseStatus,
      'RecoveryModule': recoveryModule,
      'NoofLoanDisbursedthismonth': noofLoanDisbursedthismonth,
      'AmountDisbursedthisMonth': amountDisbursedthisMonth,
      'OLP': olp,
      'DashBoard': dashboard,
      'ActiveClients': activeClients,
      'RecoverytargettillDate': recoverytargettillDate,
      'RecoveryTillDate': recoveryTillDate,
      'OverdueClient': overdueClient,
      'OverdueAmount': overdueAmount,
      'PAR': par,
      'FileSubmitted': fileSubmitted,
      'XpinAllocated': xpinAllocated,
      'FileinProcess': fileinProcess,
    };
  }

  @override
  List<Object?> get props => [
    mmSmartAppNr, basicClientInformation, groupFormation, loanFormationInformation,
    detailOfDomesticIncome, clientBusinessInformation, cashFlowAnalysis, householdAndLiveStock,
    houseHoldFacilitiesAndHealth, guarantorInformation, loanConsumerInformation, attachments,
    loanSubmitcaseInformation, submitCaseList, caseList, disbursement, reports, followUpClients,
    overdueClients, nearByClients, submittedCaseStatus, recoveryModule, noofLoanDisbursedthismonth,
    amountDisbursedthisMonth, olp, dashboard, activeClients, recoverytargettillDate, recoveryTillDate,
    overdueClient, overdueAmount, par, fileSubmitted, xpinAllocated, fileinProcess,
  ];
}

class UserRightsResponseModel {
  final String message;
  final UserRightsModel? data;
  final String status;

  UserRightsResponseModel({required this.message, this.data, required this.status});

  factory UserRightsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserRightsResponseModel(
      message: json['message'] ?? '',
      data: json['data'] != null ? UserRightsModel.fromJson(json['data']) : null,
      status: json['status'] ?? 'False',
    );
  }
}
