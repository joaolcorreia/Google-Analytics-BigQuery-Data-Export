-- Export Google Analytics BigQuery data using legacy SQL
--
-- Keep the #legacySQL comment on your query to instruct BigQuery to use legacy SQL
-- Authors:     Joao Correia <joao.correia@gmail.com>
-- License:     Apache License Version 2.0

#legacySQL
SELECT
  STRFTIME_UTC_USEC(SEC_TO_TIMESTAMP(visitStartTime + hits.time/1000),"%Y-%m-%d %H:%M:%S") as hit.timestamp,  
  -- ROUND(visitStartTime + hits.time/1000) as hits.timestamp,   /* Use for UNIX timestamp instead of timestamp */
  visitNumber,
  visitId,
  fullVisitorId,
  STRFTIME_UTC_USEC(SEC_TO_TIMESTAMP(visitStartTime),"%Y-%m-%d %H:%M:%S") as hit.visitStartTime,  
  LEFT(date,4)+"-"+SUBSTR(date,5,2)+"-"+RIGHT(date,2) as date,
  trafficSource.referralPath,
  trafficSource.campaign,
  trafficSource.source,
  trafficSource.medium,
  trafficSource.keyword,
  trafficSource.adContent,
  device.browser,
  device.browserVersion,
  device.operatingSystem,
  device.operatingSystemVersion,
  device.isMobile,
  device.mobileDeviceBranding, /* Only Availabe is later schemas */
  device.flashVersion,
  device.javaEnabled,
  device.language,
  device.screenColors,
  device.screenResolution,
  device.deviceCategory,
  geoNetwork.continent,
  geoNetwork.subContinent,
  geoNetwork.country,
  geoNetwork.region,
  geoNetwork.metro
  hits.type,
  hits.social.socialInteractionNetwork,
  hits.social.socialInteractionAction,
  hits.hitNumber,
  (hits.time/1000) as hits.time, /* Converted to seconds */
  hits.hour,
  hits.minute,
  hits.isSecure,
  hits.isInteraction,
  hits.referer,
  hits.page.pagePath,
  hits.page.hostname,
  hits.page.pageTitle,
  hits.page.searchKeyword,
  hits.page.searchCategory,

  -- Ecommerce
  hits.transaction.transactionId,
  hits.transaction.transactionRevenue,
  hits.transaction.transactionTax,
  hits.transaction.transactionShipping,
  hits.transaction.affiliation,
  hits.transaction.currencyCode,
  hits.transaction.localTransactionRevenue,
  hits.transaction.localTransactionTax,
  hits.transaction.localTransactionShipping,
  hits.transaction.transactionCoupon,
  hits.item.transactionId,
  hits.item.productName,
  hits.item.productCategory,
  hits.item.productSku,
  hits.item.itemQuantity,
  hits.item.itemRevenue,
  hits.item.currencyCode,
  hits.item.localItemRevenue,

  -- Enhanced Ecommerce
  hits.eCommerceAction.action_type, 
  hits.eCommerceAction.step,
  hits.eCommerceAction.option,

  hits.product.productSKU, 
  hits.product.v2ProductName, 
  hits.product.v2ProductCategory, 
  hits.product.productVariant, 
  hits.product.productBrand, 
  hits.product.productRevenue, 
  hits.product.localProductRevenue, 
  hits.product.productPrice, 
  hits.product.localProductPrice, 
  hits.product.productQuantity, 
  hits.product.productRefundAmount, 
  hits.product.localProductRefundAmount, 
  hits.product.isImpression,

  hits.refund.refundAmount,
  hits.refund.localRefundAmount,

  -- Promotion
  hits.promotion.promoId,
  hits.promotion.promoName,
  hits.promotion.promoCreative,
  hits.promotion.promoPosition,

  -- Mobile App
  hits.contentInfo.contentDescription,
  hits.appInfo.name,
  hits.appInfo.version,
  hits.appInfo.id,
  hits.appInfo.installerId,
  hits.appInfo.appInstallerId,
  hits.appInfo.appName,
  hits.appInfo.appVersion,
  hits.appInfo.appId,
  hits.appInfo.screenName,
  hits.appInfo.landingScreenName,
  hits.appInfo.exitScreenName,
  hits.appInfo.screenDepth,
  hits.exceptionInfo.description,
  hits.exceptionInfo.isFatal,

  -- Events
  hits.eventInfo.eventCategory,
  hits.eventInfo.eventAction,
  hits.eventInfo.eventLabel,
  hits.eventInfo.eventValue,
  

   -- Custom Dimensions (Add your custom dimensions by adding a line for each dimension)
  MAX(IF (hits.customDimensions.index = 1, hits.customDimensions.value,  NULL)) WITHIN RECORD AS dimension1,
  
  -- Custom Metrics (Add your custom metrics by adding a line for each metric)
  MAX(IF (hits.customMetrics.index = 1, hits.customMetrics.value,  NULL)) WITHIN RECORD AS metric1,
  
  -- SQL Custom Variables (Use only the )
  MAX(IF (hits.customVariables.index = 1, hits.customVariables.customVarName,   NULL)) WITHIN RECORD AS cv1Key,
  MAX(IF (hits.customVariables.index = 1, hits.customVariables.customVarValue,  NULL)) WITHIN RECORD AS cv1Value,
 
FROM [dataset_id.ga_sessions_YYYYMMDD]