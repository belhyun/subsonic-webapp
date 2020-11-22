<%@ page language="java" contentType="text/html; charset=utf-8" %>
    <!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

    <html><head>
    <%@ include file="head.jsp" %>
    <script type="text/javascript">
    if (window != window.top) {
    top.location.href = location.href;
    }
    </script>
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"
    integrity="sha256-9/aliU8dGd2tb6OSsuzixeV4y/faTqgFtohetphbbj0=" crossorigin="anonymous"></script>
    <meta charset="utf-8">
<%--    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />--%>
    </head>
    <body class="mainframe bgcolor1" onload="document.getElementById('j_username').focus()">

    <form id="loginForm" action="<c:url value="/j_acegi_security_check"/>" method="POST">
    <div class="bgcolor2 dropshadow" align="center" style="padding:20px 50px 20px 50px;
    margin-top:100px;margin-left:50px;margin-right:50px">

    <div style="margin-bottom:1em;max-width:50em;text-align:left;"><sub:wiki text="${model.loginMessage}"/></div>

    <table>
    <tr>
    <td colspan="2" align="center" style="padding-bottom:10px">
    <img
    src="http://www.ires.co.kr/board/data/board_bbs09/%ED%86%A0%EB%A5%B4%ED%94%8C%205%ED%9A%8C%20%ED%8F%AC%EC%8A%A4%ED%84%B0.JPG"
    style="height:300px; vertical-align:middle" alt="">
    <!--<span style="font-size:20px; font-weight:400; vertical-align:middle; padding-left:3px">TORFL STREAM</span>-->
    </td>
    </tr>
    <tr>
    <td align="left" style="padding-right:10px"><fmt:message key="login.username"/></td>
    <td align="left"><input type="text" id="j_username" name="j_username" style="width:12em" tabindex="1"></td>
    </tr>

    <tr>
    <td align="left" style="padding-bottom:10px"><fmt:message key="login.password"/></td>
    <td align="left" style="padding-bottom:10px"><input id="j_password" type="password" name="j_password" style="width:12em"
    tabindex="2"></td>
    </tr>

    <tr>
    <td align="left"><input name="submit" type="submit" value="<fmt:message key="login.login"/>"
    tabindex="4"></td>
    <!--
    <td align="left" class="detail">
    <input type="checkbox" name="_acegi_security_remember_me" id="remember" class="checkbox" tabindex="3">
    <label for="remember"><fmt:message key="login.remember"/></label>
    </td>
    -->
    </tr>
    <!--
    <tr>
    <td></td>
    <td align="left" class="detail"><a href="recover.view"><fmt:message key="login.recover"/></a></td>
    </tr>
    -->

    <c:if test="${model.logout}">
        <tr><td colspan="2" style="padding-top:10px"><b><fmt:message key="login.logout"/></b></td></tr>
    </c:if>
    <c:if test="${model.error}">
        <tr><td colspan="2" style="padding-top:10px"><span class="warning">
        <fmt:message key="login.error"/>
        </span></td></tr>
    </c:if>

    </table>

    <!--
    <c:if test="${model.insecure}">
        <p class="warning">
        <fmt:message key="login.insecure">
            <fmt:param value="${model.brand}"/>
        </fmt:message>
        </p>
    </c:if>
    -->

    </div>
    </form>
    </body>
    <script type="text/javascript">
    $("#loginForm").submit(function(e){
<%--        e.preventDefault();--%>
        return submitLogin();
<%--        $("#loginForm").submit();--%>
    });

    function submitLogin() {
    <%--        if ($(".warning").length == 0) {--%>
    <%--        alert("torfl.tovcard.com:8080/update-user?name="+$("#j_username").val());--%>
        let loginSuccess = true;
        if($("#j_username").val().length > 0 && $("#j_password").val().length > 0) {
            $.ajax({
                url: "http://torfl.tovcard.com:3000/get-user-check?name="+$("#j_username").val(),
                method: "get",
                async: false,
                success: function(resp) {
                    if (resp.isInFiveMinute) {
                        alert("5분 이내에 접속한 중복접속 기록이 있습니다.");
                        loginSuccess = false;
                        return false;
<%--                        return true;--%>
                    }
<%--                    $.ajax({--%>
<%--                        url: "http://torfl.tovcard.com:3000/update-user?name="+$("#j_username").val(),--%>
<%--                        method: "get",--%>
<%--                        success: function() {--%>
<%--                            return true;--%>
<%--                        },--%>
<%--                        error: function() {--%>
<%--                            return false;--%>
<%--                        }--%>
<%--                    });--%>
                },
                error: function() {
                    return false;
                }
            });
        }
        return loginSuccess;
    }
    </script>
    </html>
