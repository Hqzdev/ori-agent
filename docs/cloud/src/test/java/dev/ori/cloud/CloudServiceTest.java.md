# `CloudServiceTest.java`

Проверяет облачные сценарии с управляемыми часами и тестовыми зависимостями. Включает сессии, привязку и отзыв устройств, relay, снимки, аренду и учёт запросов модели.

[Исходник: `backend/cloud/src/test/java/dev/ori/cloud/CloudServiceTest.java`](../../../../../../../../backend/cloud/src/test/java/dev/ori/cloud/CloudServiceTest.java)

Модуль: [cloud](../../../../../../README.md). Раздел: [Проверки облака](index.md).

## Проверки

- `accountDeletionRequiresItsOwnCodeAndRemovesTheOwnerGraph`
- `browserAuthorizationRequiresPKCEAndBindsOneNativeClient`
- `webBrowserAuthorizationUsesTheConfiguredOriginAndExistingOwner`
- `emailVerificationRotatingSessionsAndDeviceProofAreRequired`
- `pairingRequiresOwnerConfirmationAndCannotReplaceCandidate`
- `relayIsDurableIdempotentSignedAndExpiresWithExplicitReplayFailure`
- `snapshotDonorMustBeCurrentSignedAndCompleteBeforePublication`
- `leasesFenceProcessesAndRequireUnknownActionReconciliation`
- `revocationAtomicallyRotatesEpochAndBlocksOldDeviceAndCiphertext`
- `quotaDoesNotDoubleChargeAndUnknownReservationsSurviveRestart`
- `encryptedBlobChunksKeepTheirManifestAndExpire`
- `resetDoesNotRevealExistenceThroughCooldownOrSmtpFailure`
- `modelInvocationIsClaimedOnceAndLogoutStopsQueuedCalls`
