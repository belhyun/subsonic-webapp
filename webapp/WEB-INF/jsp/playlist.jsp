<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="iso-8859-1"%>

<html><head>
    <%@ include file="head.jsp" %>
    <%@ include file="jquery.jsp" %>
    <script type="text/javascript" src="<c:url value='/dwr/util.js'/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/engine.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/playlistService.js"/>"></script>
    <script type="text/javascript" src="<c:url value="/dwr/interface/starService.js"/>"></script>
    <script type="text/javascript" language="javascript">

        var playlist;
        var songs;

        function init() {
            dwr.engine.setErrorHandler(null);
            $("#dialog-edit").dialog({resizable: true, width:400, autoOpen: false,
                buttons: {
                    "<fmt:message key="common.save"/>": function() {
                        $(this).dialog("close");
                        var name = $("#newName").val();
                        var comment = $("#newComment").val();
                        var shared = $("#newShared").is(":checked");
                        $("#name").text(name);
                        $("#comment").text(comment);
                        playlistService.updatePlaylist(playlist.id, name, comment, shared, function (playlistInfo){playlistCallback(playlistInfo)});
                    },
                    "<fmt:message key="common.cancel"/>": function() {
                        $(this).dialog("close");
                    }
                }});

            $("#dialog-delete").dialog({resizable: false, height: 170, autoOpen: false,
                buttons: {
                    "<fmt:message key="common.delete"/>": function() {
                        $(this).dialog("close");
                        playlistService.deletePlaylist(playlist.id, function (){location.href = "playlists.view";});
                    },
                    "<fmt:message key="common.cancel"/>": function() {
                        $(this).dialog("close");
                    } 
                }});

            $("#playlistBody").sortable({
                stop: function(event, ui) {
                    var indexes = [];
                    $("#playlistBody").children().each(function() {
                        var id = $(this).attr("id").replace("pattern", "");
                        if (id.length > 0) {
                            indexes.push(parseInt(id) - 1);
                        }
                    });
                    onRearrange(indexes);
                },
                cursor: "move",
                axis: "y",
                containment: "parent",
                helper: function(e, tr) {
                    var originals = tr.children();
                    var trclone = tr.clone();
                    trclone.children().each(function(index) {
                        // Set cloned cell sizes to match the original sizes
                        $(this).width(originals.eq(index).width());
                        $(this).css("maxWidth", originals.eq(index).width());
                        $(this).css("border-top", "1px solid black");
                        $(this).css("border-bottom", "1px solid black");
                    });
                    return trclone;
                }
            });

            getPlaylist();
        }

        function getPlaylist() {
            playlistService.getPlaylist(${model.playlist.id}, playlistCallback);
        }

        function playlistCallback(playlistInfo) {
            this.playlist = playlistInfo.playlist;
            this.songs = playlistInfo.entries;

            if (songs.length == 0) {
                $("#empty").show();
                $("#playlistTable").hide();
            } else {
                $("#empty").hide();
                $("#playlistTable").show();
            }

            $("#songCount").html(playlist.fileCount);
            $("#duration").html(playlist.durationAsString);

            if (playlist.shared) {
                $("#shared").html("<fmt:message key="playlist2.shared"/>");
            } else {
                $("#shared").html("<fmt:message key="playlist2.notshared"/>");
            }

            // Delete all the rows except for the "pattern" row
            dwr.util.removeAllRows("playlistBody", { filter:function(tr) {
                return (tr.id != "pattern");
            }});

            // Create a new set cloned from the pattern row
            for (var i = 0; i < songs.length; i++) {
                var song  = songs[i];
                var id = i + 1;
                dwr.util.cloneNode("pattern", { idSuffix:id });
                $("#starSong" + id).addClass(song.starred ? "fa-star starred" : "fa-star-o");
                if (!song.present) {
                    $("#missing" + id).show();
                }
                $("#index" + id).html(id);
                $("#title" + id).html(song.title);
                $("#title" + id).attr("title", song.title);
                $("#album" + id).html(song.album);
                $("#album" + id).attr("title", song.album);
                $("#albumUrl" + id).attr("href", "main.view?id=" + song.id);
                $("#artist" + id).html(song.artist);
                $("#artist" + id).attr("title", song.artist);
                $("#songDuration" + id).html(song.durationAsString);

                // Note: show() method causes page to scroll to top.
                $("#pattern" + id).css("display", "table-row");
            }
        }

        function onPlay(index) {
            top.playQueue.onPlayPlaylist(playlist.id, false, index);
        }
        function onPlayAll() {
            top.playQueue.onPlayPlaylist(playlist.id, false);
        }
        function onShuffle() {
            top.playQueue.onShufflePlaylist(playlist.id);
        }
        function onAdd(index) {
            top.playQueue.onAdd(songs[index].id);
            $().toastmessage('showSuccessToast', '<fmt:message key="main.addlast.toast"/>')
        }
        function onAddNext(index) {
            top.playQueue.onAddNext(songs[index].id);
            $().toastmessage('showSuccessToast', '<fmt:message key="main.addnext.toast"/>')
        }
        function onStar(index) {
            playlistService.toggleStar(playlist.id, index, playlistCallback);
        }
        function onRemove(index) {
            playlistService.remove(playlist.id, index, function (playlistInfo){playlistCallback(playlistInfo)});
        }
        function onRearrange(indexes) {
            playlistService.rearrange(playlist.id, indexes, playlistCallback);
        }
        function onEditPlaylist() {
            $("#dialog-edit").dialog("open");
        }
        function onDeletePlaylist() {
            $("#dialog-delete").dialog("open");
        }

    </script>

    <style type="text/css">
        .playlist-missing {
            color: red;
            border: 1px solid red;
            display: none;
            font-size: 90%;
            padding-left: 5px;
            padding-right: 5px;
            margin-right: 5px;
        }
        #playButton {
            cursor: pointer;
            font-size:24px;
            color:#E65100;
            margin-left:1.0em;
            margin-right:0.5em;
        }
        #playButton:hover {
            opacity: 0.8;
        }
        #empty, #playlistTable {
            display: none;
        }
    </style>
</head>
<body class="mainframe bgcolor1" onload="init()">

<div style="float:left;margin-right:1.5em;margin-bottom:1.5em">
<c:import url="coverArt.jsp">
    <c:param name="playlistId" value="${model.playlist.id}"/>
    <c:param name="showPlay" value="${model.user.streamRole}"/>
    <c:param name="coverArtSize" value="200"/>
</c:import>
</div>


<div style="display:flex; align-items:center">

    <div style="flex-shrink:1" class="ellipsis">
        <h1 class="ellipsis"><a href="playlists.view"><fmt:message key="left.playlists"/></a> &nbsp;&bull;&nbsp; <span id="name">${fn:escapeXml(model.playlist.name)}</span></h1>
        <h2 class="ellipsis">

            <c:if test="${model.user.streamRole}">
                <span class="header" style="padding-left:0"><a href="javascript:void(0)" onclick="onShuffle();"><fmt:message key="common.shuffle"/></a></span> |
            </c:if>
            <c:if test="${model.user.downloadRole}">
                <c:url value="download.view" var="downloadUrl"><c:param name="playlist" value="${model.playlist.id}"/></c:url>
                <span class="header"><a href="${downloadUrl}"><fmt:message key="common.download"/></a></span> |
            </c:if>
            <c:if test="${model.user.shareRole}">
                <c:url value="createShare.view" var="shareUrl"><c:param name="playlist" value="${model.playlist.id}"/></c:url>
                <span class="header"><a href="${shareUrl}"><fmt:message key="share.title"/></a></span> |
            </c:if>

            <c:if test="${model.editAllowed}">
                <span class="header"><a href="javascript:void(0)" onclick="onEditPlaylist();"><fmt:message key="common.edit"/></a></span> |
                <span class="header"><a href="javascript:void(0)" onclick="onDeletePlaylist();"><fmt:message key="common.delete"/></a></span> |
            </c:if>

            <c:url value="exportPlaylist.view" var="exportUrl"><c:param name="id" value="${model.playlist.id}"/></c:url>
            <span class="header"><a href="${exportUrl}"><fmt:message key="playlist2.export"/></a></span>
        </h2>
    </div>

    <c:if test="${model.user.streamRole}">
        <span id="playButton" class="fa-stack fa-lg" onclick="onPlayAll()">
            <i class="fa fa-circle fa-stack-2x fa-inverse"></i>
            <i class="fa fa-play-circle fa-stack-2x"></i>
        </span>
    </c:if>
</div>

<div id="comment" class="detail" style="padding-top:0.2em">${fn:escapeXml(model.playlist.comment)}</div>

<div class="detail" style="padding-top:0.2em">
    <span id="songCount"></span> <fmt:message key="playlist2.songs"/> &ndash; <span id="duration"></span>
</div>
<div class="detail" style="padding-top:0.2em">
    <fmt:message key="playlist2.created" var="created">
        <fmt:param>${model.playlist.username}</fmt:param>
        <fmt:param><fmt:formatDate type="date" dateStyle="long" value="${model.playlist.created}"/></fmt:param>
    </fmt:message>
    ${fn:escapeXml(created)}.
</div>
<div class="detail" style="padding-top:0.2em">
    <span id="shared"></span>.
</div>

<div style="height:0.7em;clear:both"></div>

<p id="empty"><em><fmt:message key="playlist2.empty"/></em></p>

<table id="playlistTable" class="music">
    <thead>
    <tr></tr>
    <tr>
        <th colspan="${model.user.streamRole ? 4 : 1}"></th>
        <th class="fit right">#</th>
        <th></th>
        <th class="truncate"><fmt:message key="lyrics.song"/></th>
        <th class="truncate"><fmt:message key="personalsettings.album"/></th>
        <th class="truncate"><fmt:message key="personalsettings.artist"/></th>
        <th class="fit center"><i class="fa fa-lg fa-clock-o"></i></th>
        <th class="fit center"><fmt:message key="common.delete"/></th>
    </tr>
    </thead>
    <tbody id="playlistBody" style="cursor:pointer">
    <tr id="pattern" style="display:none;margin:0;padding:0;border:0">
        <td class="fit">
            <i id="starSong" class="fa clickable" onclick="onStar(this.id.substring(8) - 1)"></i>
        </td>

        <c:if test="${model.user.streamRole}">
            <td class="fit">
                <i id="play" class="fa fa-play clickable icon" onclick="onPlay(this.id.substring(4) - 1)" title="<fmt:message key="common.play"/>"></i>
            </td>
            <td class="fit">
                <i id="add" class="fa fa-plus clickable icon" onclick="onAdd(this.id.substring(3) - 1)" title="<fmt:message key="common.add"/>"></i>
            </td>
            <td class="fit" style="padding-right:30px">
                <i id="addNext" class="fa fa-arrow-right clickable icon" onclick="onAddNext(this.id.substring(7) - 1)" title="<fmt:message key="main.addnext"/>"></i>
            </td>
        </c:if>
        <td class="fit right"><span id="index">1</span></td>
        <td class="fit left"><span id="missing" class="playlist-missing"><fmt:message key="playlist.missing"/></span></td>
        <td class="truncate"><span id="title" class="songTitle">Title</span></td>
        <td class="truncate"><a id="albumUrl" target="main"><span id="album" class="detail">Album</span></a></td>
        <td class="truncate"><span id="artist" class="detail">Artist</span></td>
        <td class="fit right"><span id="songDuration" class="detail">Duration</span></td>

        <c:if test="${model.editAllowed}">
            <td class="fit center">
                <i id="removeSong" class="fa fa-remove clickable icon" onclick="onRemove(this.id.substring(10) - 1)" title="<fmt:message key="playlist.remove"/>"></i>
            </td>
        </c:if>
    </tr>
    </tbody>
</table>

<div id="dialog-delete" title="<fmt:message key="common.confirm"/>" style="display: none;">
    <p><span class="ui-icon ui-icon-alert" style="float:left; margin:0 7px 20px 0;"></span>
        <fmt:message key="playlist2.confirmdelete"/></p>
</div>

<div id="dialog-edit" title="<fmt:message key="common.edit"/>" style="display: none;">
    <form>
        <label for="newName" style="display:block;"><fmt:message key="playlist2.name"/></label>
        <input type="text" name="newName" id="newName" value="${fn:escapeXml(model.playlist.name)}" class="ui-widget-content"
               style="display:block;width:95%;"/>
        <label for="newComment" style="display:block;margin-top:1em"><fmt:message key="playlist2.comment"/></label>
        <input type="text" name="newComment" id="newComment" value="${fn:escapeXml(model.playlist.comment)}" class="ui-widget-content"
               style="display:block;width:95%;"/>
        <input type="checkbox" name="newShared" id="newShared" ${model.playlist.shared ? "checked='checked'" : ""} style="margin-top:1.5em" class="ui-widget-content"/>
        <label for="newShared"><fmt:message key="playlist2.public"/></label>
    </form>
</div>

</body></html>
