<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1" %>
<%--@elvariable id="model" type="Map"--%>

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
</head>
<body class="mainframe bgcolor1">

<c:set var="category" value="share"/>
<c:set var="toast" value="${model.toast}"/>
<c:set var="user" value="${model.user}"/>
<%@ include file="settingsHeader.jsp" %>

<form method="post" action="shareSettings.view">

    <table class="music indent">
        <tr>
            <th style="padding-left:1em"><fmt:message key="sharesettings.name"/></th>
            <th style="padding-left:1em"><fmt:message key="sharesettings.owner"/></th>
            <th style="padding-left:1em"><fmt:message key="sharesettings.description"/></th>
            <th style="padding-left:1em"><fmt:message key="sharesettings.lastvisited"/></th>
            <th style="padding-left:1em" class="right"><fmt:message key="sharesettings.visits"/></th>
            <th style="padding-left:1em"><fmt:message key="sharesettings.files"/></th>
            <th style="padding-left:1em"><fmt:message key="sharesettings.expires"/></th>
            <th style="padding-left:1em"><fmt:message key="sharesettings.expirein"/></th>
            <th style="padding-left:1em" class="center"><fmt:message key="common.delete"/></th>
        </tr>

        <c:forEach items="${model.shareInfos}" var="shareInfo" varStatus="loopStatus">
            <c:set var="share" value="${shareInfo.share}"/>

            <c:url value="main.view" var="albumUrl">
                <c:param name="id" value="${shareInfo.dir.id}"/>
            </c:url>

            <tr>
                <td style="padding-left:1em"><a href="${model.shareBaseUrl}${share.name}" target="_blank">${share.name}</a></td>
                <td style="padding-left:1em">${fn:escapeXml(share.username)}</td>
                <td style="padding-left:1em"><input type="text" name="description[${share.id}]" size="40" value="${share.description}"/></td>
                <td style="padding-left:1em"><fmt:formatDate value="${share.lastVisited}" type="date" dateStyle="medium"/></td>
                <td style="padding-left:1em" class="right">${share.visitCount}</td>
                <td style="padding-left:1em"><a href="${albumUrl}" title="${shareInfo.dir.name}"><str:truncateNicely upper="30">${fn:escapeXml(shareInfo.dir.name)}</str:truncateNicely></a></td>
                <td style="padding-left:1em"><fmt:formatDate value="${share.expires}" type="date" dateStyle="medium"/></td>
                <td style="padding-left:1em">
                    <label><input type="radio" name="expireIn[${share.id}]" value="7"><fmt:message key="sharesettings.expirein.week"/></label>
                    <label><input type="radio" name="expireIn[${share.id}]" value="30"><fmt:message key="sharesettings.expirein.month"/></label>
                    <label><input type="radio" name="expireIn[${share.id}]" value="365"><fmt:message key="sharesettings.expirein.year"/></label>
                    <label><input type="radio" name="expireIn[${share.id}]" value="0"><fmt:message key="sharesettings.expirein.never"/></label>
                </td>
                <td style="padding-left:1em" class="center"><input type="checkbox" name="delete[${share.id}]" class="checkbox"/></td>
            </tr>
        </c:forEach>

    </table>

    <c:set var="licenseInfo" value="${model.licenseInfo}"/>
    <%@ include file="licenseNotice.jsp" %>

    <p style="padding-top:1em">
        <input type="submit" value="<fmt:message key="common.save"/>" style="margin-right:0.3em">
        <input type="button" value="<fmt:message key="common.cancel"/>" onclick="location.href='nowPlaying.view'" style="margin-right:2.0em">
        <input type="checkbox" id="deleteExpired" name="deleteExpired" class="checkbox"/>
        <label for="deleteExpired"><fmt:message key="sharesettings.deleteexpired"/></label>
    </p>

</form>

</body></html>