CREATE procedure [dbo].[cSaveSSPartner_sp]
@SystemUserID uniqueidentifier,
@PrivateLabelID uniqueidentifier,
@PartnerID uniqueidentifier,
@Name varchar(100),
@PortPlayerID uniqueidentifier = null,
@DomainName varchar(50),
@Node1Name varchar(50),
@CommunityTypeID int = null,
@ErrorCode tinyint = null output,
@NetworkID uniqueidentifier = null,
@NetworkNumID bigint = null,
@CompanyTypeID int = 3,
@Folder varchar(500) = null output,
@NumID int = null
as
SET TRANSACTION ISOLATION LEVEL SNAPSHOT
set nocount on
declare
@ReturnCode int,
@StatusID int,
@StatusDTM datetime,
@NewPartnerInd tinyint,
@ProcessDTM datetime,
@ID int,
@ReportID uniqueidentifier,
@PartnerReportID uniqueidentifier,
@TranCount int,
@Operation varchar(50),
@Directory nvarchar(200),
@LoopDirectory nvarchar(200),
@i int,
@DesktopName nvarchar(200),
@SuperGroupID uniqueidentifier,
@PartnerGroupUserID uniqueidentifier,
@ReaderVisibleInd tinyint,
@AdminVisibleInd tinyint,
@ToolsVisibleInd tinyint,
@CommunityVisibleInd tinyint,
@AllowGuestsInd tinyint,
@HomeVisibleInd tinyint,
@SiteDefaultContentInd tinyint,
@SiteUserLandingInd tinyint,
@SiteAnonLandingInd tinyint,
@AllowAnonCmtsInd tinyint,
@ShowTopFeedInd tinyint,
@BlastVisibleInd tinyint,
@ProfileVisibleInd tinyint,
@PublicAccessPageID int,
@AdminCommFeedsInd tinyint,
@FramedVersionInd tinyint,
@AutoBlogTypeID int,
@NumBlogsAllowed tinyint,
@BlogFeedbackInd tinyint,
@CommunityContentRatingInd tinyint,
@SendContentRejectionEmailInd tinyint,
@AdvertisingFocusInd tinyint,
@ShowReportsInd tinyint,
@NonFrameWidth varchar(10),
@NonFrameAlignment tinyint,
@ReaderWidth varchar(10),
@ReaderAlignment tinyint,
@HideNavigationInd tinyint,
@AuthenticatePublicSitesInd tinyint,
@WordFilterInd tinyint,
@SiteDomainAssignmentInd tinyint,
@ShareMainPhotoInd tinyint,
@AllowTagsInBlogEntryInd tinyint,
@AllowInboxInd tinyint,
@AllowOnlineVisibilityInd tinyint,
@AllowProfileEditInd tinyint,
@AllowTagAdminInd tinyint,
@AllowListAdminInd tinyint,
@VideoHostingOverrideInd tinyint,
@VideoModerationInd tinyint,
@MaxVideos int,
@MaxPhotoAlbums int,
@FeedItemToolsInd tinyint,
@ReaderPreferencesInd tinyint,
@MenuPosition tinyint,
@RedirectLandingPage varchar(75),
@MoreVisibleInd tinyint,
@NewspaperInd tinyint
set @CommunityContentRatingInd = 0
set @SendContentRejectionEmailInd = 0
set @AdvertisingFocusInd = 0
set @ShowReportsInd = 0
set @NonFrameWidth = '100%'
set @NonFrameAlignment = 1
set @ReaderWidth = '100%'
set @ReaderAlignment = 1
set @HideNavigationInd = 2
set @AuthenticatePublicSitesInd = 0
set @WordFilterInd = 0
set @SiteDomainAssignmentInd = 1
set @ShareMainPhotoInd = 0
set @AllowTagsInBlogEntryInd = 3
set @AllowInboxInd = 1
set @AllowOnlineVisibilityInd = 1
set @AllowProfileEditInd = 1
set @AllowTagAdminInd = 1
set @AllowListAdminInd = 1
set @VideoHostingOverrideInd = 1
set @VideoModerationInd = 5
set @MaxPhotoAlbums = 1
set @MaxVideos = 0
set @FeedItemToolsInd = 1
set @ReaderPreferencesInd = 1
set @MenuPosition = 1
set @RedirectLandingPage = '/community/app/nf/vistafs.aspx'
set @MoreVisibleInd = 0
set @NewspaperInd = 0
set @i = 1
set @ProcessDTM = getdate()
set @NewPartnerInd = 0
set @ErrorCode = 0
set @ReturnCode = 0
set @ProfileVisibleInd = 1
set @CommunityTypeID = isnull(@CommunityTypeID,2)
if isnull(@DomainName,'') <> '' and
isnull(@Node1Name,'') <> '' and
exists
(
select
*
from
PartnerBlogNode1Domain ND with(nolock)
inner join DomainPartner DP with(nolock) on DP.ID = ND.DomainPartnerID and DP.Domain = @DomainName and DomainTypeID = 1
where
ND.PartnerID <> @PartnerID and
ND.Node1Text = @Node1Name
)
begin
set @ErrorCode = 1
return(0)
end
select @TranCount = @@trancount
if @TranCount = 0
begin
begin tran T_cSavePartner_sp_
end
else
begin
save tran T_cSavePartner_sp_
end
select
@StatusID = StatusID,
@StatusDTM = StatusDTM
from
Company with(nolock)
where
ID = @PartnerID
if @StatusID is null
begin
set @NewPartnerInd = 1
set @StatusID = 110
set @StatusDTM = @ProcessDTM
end
exec @ReturnCode = gCompany_s
@SystemUserID = @SystemUserID,
@ID = @PartnerID,
@Name = @Name,
@Descr = null,
@CompanyTypeID = @CompanyTypeID,
@LicenseTypeID = 1,
@LicenseQty = 0,
@LicenseFee = 0,
@ParentCompanyID = @PartnerID,
@NetworkID = @NetworkID,
@NetworkNumID = @NetworkNumID,
@StatusID = @StatusID,
@StatusDTM = @StatusDTM,
@PrivateLabelID = @PrivateLabelID,
@NumID = @NumID
if @ReturnCode <> 0
begin
select @Operation = 'gCompany_s'
goto OnError
end
SET @Directory = @Folder
IF @Directory IS NULL
BEGIN
select @Directory = replace(replace(replace(replace(replace(lower(@Name),' ',''),'&',''),'.',''),'/',''),'\','')
END
set @LoopDirectory = @Directory
while exists (select * from CompanyLayout with(nolock) where Directory = @LoopDirectory and CompanyID <> @PartnerID)
begin
set @LoopDirectory = @Directory + convert(nvarchar,@i)
set @i = @i + 1
end
set @Directory = @LoopDirectory
if isnull(@Directory,'') <> ''
begin
exec @ReturnCode = gCompanyLayout_s
@SystemUserID = @SystemUserID,
@CompanyID = @PartnerID,
@Directory = @Directory,
@HeaderFile = null,
@FooterFile = null,
@LogoFile = null,
@IEStylesheetFile = null,
@NSStylesheetFile = null,
@StatusID = 151,
@StatusDTM = @ProcessDTM,
@PrivateLabelID = @PrivateLabelID
if @ReturnCode <> 0
begin
select @Operation = 'gCompanyLayout_s'
goto OnError
end
end
SET @Folder = @Directory
if @PortPlayerID is not null
begin
set @DesktopName = ltrim(rtrim(@Name))
exec @ReturnCode = gPortPlayer_s
@SystemUserID = @SystemUserID,
@ID = @PortPlayerID,
@Name = @Name,
@DesktopName = @DesktopName,
@StatusID = 52,
@StatusDTM = @ProcessDTM,
@LanguageID = 1,
@BusinessTypeID = 1,
@LoginIDReqInd = 1,
@EmailReqInd = 1,
@AuthenticationInd = 1,
@DesktopShortcutInd = 1,
@OnStartInd = 1,
@OptOutURL = 0,
@BlogAutoInd = 0,
@CreateDTM = @ProcessDTM,
@PortPlayerTemplateID = 'B792BD90-ED5B-4512-8A8E-459111D232F9',
@PartnerID = @PartnerID,
@PrivateLabelID = @PrivateLabelID,
@NicknameReqInd = 0
if @ReturnCode <> 0
begin
select @Operation = 'gPortPlayer_s'
goto OnError
end
end
select
@ReaderVisibleInd = ReaderVisibleInd,
@AdminVisibleInd = AdminVisibleInd,
@ToolsVisibleInd = ToolsVisibleInd,
@CommunityVisibleInd = CommunityVisibleInd,
@AllowGuestsInd = AllowGuestsInd,
@SiteDefaultContentInd = SiteDefaultContentInd,
@SiteUserLandingInd = SiteUserLandingInd,
@SiteAnonLandingInd = SiteAnonLandingInd,
@AllowAnonCmtsInd =AllowAnonCmtsInd,
@ShowTopFeedInd =ShowTopFeedInd,
@BlastVisibleInd = BlastVisibleInd,
@ProfileVisibleInd = ProfileVisibleInd,
@PublicAccessPageID = PublicAccessPageID,
@AdminCommFeedsInd = AdminCommFeedInd,
@FramedVersionInd = FramedVersionInd,
@AutoBlogTypeID = AutoBlogTypeID,
@NumBlogsAllowed = NumBlogsAllowed,
@BlogFeedbackInd = BlogFeedbackInd
from
CommunityType
where
ID = @CommunityTypeID
if not exists (select * from PartnerBlogOption with(nolock) where PartnerID = @PartnerID)
begin
exec @ReturnCode = cSavePartnerBlogOptions_sp
@SystemUserID = @SystemUserID,
@PartnerID = @PartnerID,
@BlogSynonym = 'Blog',
@BlogSynonymPlural = 'Blogs',
@BlogSynonymPrefix = 'a',
@AudienceSynonym = 'Audience',
@AudienceSynonymPlural = 'Audiences',
@AudienceSynonymPrefix = 'an',
@ApproveDirectoryBlogInd = 0,
@RestrictNode1Ind = 1,
@DomainName = @DomainName,
@Node1Name = @Node1Name,
@WeatherURL = null,
@NewsFeedURL = null,
@HomeURL = null,
@HomeURLTooltip = null,
@DefaultSearchURL = null,
@DefaultSearchName = null,
@AllowBlogPubInd = 1,
@PublicAccessPageID = @PublicAccessPageID,
@RdrPortPlayerID = @PortPlayerID,
@ConfirmEmailInd = 0,
@OpenCommunityInd = 0,
@MaxHomePageFeeds = 10,
@AddReportBlogLinkInd = 1,
@AdminVisibleInd = 0,
@ReaderVisibleInd = @ReaderVisibleInd,
@HomeVisibleInd = 0,
@HomePanelVisibleInd = 1,
@ToolsVisibleInd = @ToolsVisibleInd,
@CommunityVisibleInd = @CommunityVisibleInd,
@ProfileVisibleInd = @ProfileVisibleInd,
@CommunityTypeID = @CommunityTypeID,
@AllowGuestsInd = @AllowGuestsInd,
@SiteDefaultContentInd = @SiteDefaultContentInd,
@SiteUserLandingInd = @SiteUserLandingInd,
@SiteAnonLandingInd = @SiteAnonLandingInd,
@AllowAnonCmtsInd = @AllowAnonCmtsInd,
@ShowTopFeedInd =@ShowTopFeedInd,
@BlastVisibleInd = @BlastVisibleInd,
@AdminCommFeedsInd = @AdminCommFeedsInd,
@FramedVersionInd = @FramedVersionInd,
@AutoBlogTypeID = @AutoBlogTypeID,
@NumBlogsAllowed = @NumBlogsAllowed,
@BlogFeedbackInd = @BlogFeedbackInd,
@CommunityContentRatingInd = @CommunityContentRatingInd,
@SendContentRejectionEmailInd = @SendContentRejectionEmailInd,
@AdvertisingFocusInd = @AdvertisingFocusInd,
@ShowReportsInd = @ShowReportsInd,
@NonFrameWidth = @NonFrameWidth,
@NonFrameAlignment = @NonFrameAlignment,
@ReaderWidth = @ReaderWidth,
@ReaderAlignment = @ReaderAlignment,
@HideNavigationInd = @HideNavigationInd,
@AuthenticatePublicSitesInd = @AuthenticatePublicSitesInd,
@WordFilterInd = @WordFilterInd,
@SiteDomainAssignmentInd = @SiteDomainAssignmentInd,
@ShareMainPhotoInd = @ShareMainPhotoInd,
@AllowTagsInBlogEntryInd = @AllowTagsInBlogEntryInd,
@AllowInboxInd = @AllowInboxInd,
@AllowOnlineVisibilityInd = @AllowOnlineVisibilityInd,
@AllowProfileEditInd = @AllowProfileEditInd,
@AllowTagAdminInd = @AllowTagAdminInd,
@AllowListAdminInd = @AllowListAdminInd,
@VideoHostingOverrideInd = @VideoHostingOverrideInd,
@VideoModerationInd = @VideoModerationInd,
@MaxVideos = @MaxVideos,
@FeedItemToolsInd = @FeedItemToolsInd,
@ReaderPreferencesInd = @ReaderPreferencesInd,
@MaxPhotoAlbums = @MaxPhotoAlbums ,
@MoreVisibleInd = @MoreVisibleInd,
@NewspaperInd = @NewspaperInd
if @ReturnCode <> 0
begin
select @Operation = 'cSavePartnerBlogOptions_sp'
goto OnError
end
exec @ReturnCode = cSavePartnerNewspaper_sp
@SystemUserID = @SystemUserID,
@PartnerID = @PartnerID,
@NewspaperTypeID = 1,
@MenuPosition = @MenuPosition
if @ReturnCode <> 0
begin
select @Operation = 'cSavePartnerNewspaper_sp'
goto OnError
end
end
if not exists (select * from PartnerURL with(nolock) where PartnerID = @PartnerID)
begin
exec @ReturnCode = cSavePartnerURLs_sp
@SystemUserID = @SystemUserID,
@PartnerID = @PartnerID,
@URLString = 'READER_MAIN_PAGE|/blogpublisher/app/home/newspaper.aspx|||'
if @ReturnCode <> 0
begin
select @Operation = 'cSavePartnerURLs_sp'
goto OnError
end
end
if not exists (select * from PartnerBlogTemplate where PartnerID = @PartnerID)
begin
insert into PartnerBlogTemplate
select
newid(),BlogTemplateID, null, @PartnerID, DefaultInd, SortSeq, StatusID, @ProcessDTM, @SystemUserID, @ProcessDTM, @SystemUserID, @ProcessDTM
from
CommunityTypeBlogTemplate with(nolock)
where
CommunityTypeID = @CommunityTypeID
select @ReturnCode = @@error
if @ReturnCode <> 0
begin
select @Operation = 'insert PartnerBlogTemplate'
goto OnError
end
end
DECLARE @FriendlyURL VarChar(200)
SET @FriendlyURL = @Node1Name + '.' + @DomainName
IF NOT EXISTS
(
SELECT
FriendlyURL
FROM
RedirectURL (NOLOCK)
WHERE
FriendlyURL = @FriendlyURL AND
ObjectID = @PartnerID
)
BEGIN
EXEC @ReturnCode = bSaveRedirectURL_sp
@SystemUserID = @SystemUserID
,@FriendlyURL = @FriendlyURL
,@RenderPage = @RedirectLandingPage
,@PartnerID = @PartnerID
,@ObjectTypeID = 4
,@ObjectID = @PartnerID
,@RewriteInd = 0
if @ReturnCode <> 0
begin
select @Operation = 'bSaveRedirectURL_sp'
goto OnError
end
END
if @NewPartnerInd = 1
begin
select @SuperGroupID = newid()
exec @ReturnCode= gPartnerGroup_s
@SystemUserID = @SystemUserID,
@ID = @SuperGroupID,
@PartnerID = @PartnerID,
@Label = 'Super User',
@Descr = '',
@SuperUserInd = 1,
@InternalInd = 1,
@SortSeq = 0,
@StatusID = 1,
@StatusDTM = @ProcessDTM
if @ReturnCode <> 0
begin
select @Operation = 'PartnerGroupID'
goto OnError
end
insert into PartnerGroupPermission
select
newid(),@SuperGroupID, @PartnerID, ID, @SystemUserID, @ProcessDTM, @SystemUserID, @ProcessDTM
from
Permission with(nolock)
where
PermissionGroupID = 10 and
StatusID = 1
select @ReturnCode = @@error
if @ReturnCode <> 0
begin
select @Operation = 'insert PartnerGroupPermission'
goto OnError
end
if exists (select * from EventCategory with(nolock) where PartnerID = @PrivateLabelID and StatusID = 1)
begin
insert into EventCategory
(ID, Title, PartnerID, SortSeq, StatusID, StatusDTM, EnterUserID, EnterDTM, LastChgUserID, LastChgDTM)
select
newid(), EC.Title, @PartnerID, EC.SortSeq, EC.StatusID, EC.StatusDTM, @SystemUserID,@ProcessDTM, @SystemUserID, @ProcessDTM
from
EventCategory EC with(nolock)
where
PartnerID = @PrivateLabelID and
StatusID = 1
select @ReturnCode = @@error
if @ReturnCode <> 0
begin
select @Operation = 'insert EventCategory'
goto OnError
end
end
exec @ReturnCode = gPartnerSetting_s
@SystemUserID = @SystemUserID,
@PartnerID = @PartnerID,
@RedirectLandingPage = @RedirectLandingPage
if @ReturnCode <> 0
begin
select @Operation = 'gPartnerSetting_s'
goto OnError
end
end
if @TranCount = 0
commit tran T_cSavePartner_sp_
return(0)
OnError:
rollback tran T_cSavePartner_sp_
raiserror('$SP_ERR$SP: cSaveSSPartner_sp ReturnCode: %d Operation: %s',18, 1, @ReturnCode, @Operation)
return(1)