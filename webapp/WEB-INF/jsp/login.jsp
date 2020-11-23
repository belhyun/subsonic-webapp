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
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta charset="utf-8">
    <%--    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />--%>
    <link rel="stylesheet" href="<c:url value="/script/Login_v3/vendor/bootstrap/css/bootstrap.min.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/fonts/Login_v3/fonts/font-awesome-4.7.0/css/font-awesome.min.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/fonts/Login_v3/fonts/iconic/css/material-design-iconic-font.min.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/script/Login_v3/vendor/animate/animate.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/script/Login_v3/vendor/css-hamburgers/hamburgers.min.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/script/Login_v3/vendor/animsition/css/animsition.min.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/script/Login_v3/vendor/select2/select2.min.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/script/Login_v3/vendor/daterangepicker/daterangepicker.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/style/Login_v3/css/util.css"/>" type="text/css">
    <link rel="stylesheet" href="<c:url value="/style/Login_v3/css/main.css"/>" type="text/css">
</head>
<body>
<body onload="document.getElementById('j_username').focus()">

<div class="limiter">
    <div class="container-login100" style="background-image: url('/icons/Login_v3/images/bg-01.jpg');">
        <div class="wrap-login100" style="background:#E65100;width:500px;">
            <form id="loginForm" class="login100-form" action="<c:url value="/j_acegi_security_check"/>" method="POST">
                <!--
					<span class="login100-form-logo">
						<i class="zmdi zmdi-landscape"></i>
                        <img src="http://torfl.or.kr/theme/basic/image/logo.jpg"/>
					</span>
                 -->
                <span class="login100-form-title p-b-34 p-t-27">
                    <!--
                    <div>
                        <img src="http://torfl.or.kr/theme/basic/image/logo.jpg" style="text-align: center"/>
                    </div>
                    -->
                    러시아 토플 듣기 시스템
					</span>

                <div class="wrap-input100 validate-input" data-validate = "사용자명을 입력하세요">
                    <input class="input100" type="text" name="j_username" id="j_username" name="j_username" placeholder="사용자명">
                    <span class="focus-input100" data-placeholder="&#xf207;"></span>
                </div>

                <div class="wrap-input100 validate-input" data-validate="비밀번호를 입력하세요">
                    <input class="input100" id="j_password" type="password" name="j_password" type="password" placeholder="비밀번호">
                    <span class="focus-input100" data-placeholder="&#xf191;"></span>
                </div>

                <!--
                <div class="contact100-form-checkbox">
                    <input class="input-checkbox100" id="ckb1" type="checkbox" name="remember-me">
                    <label class="label-checkbox100" for="ckb1">
                        Remember me
                    </label>
                </div>
                -->

                <div class="container-login100-form-btn">
                    <button name="submit" type="submit" class="login100-form-btn" value="<fmt:message key="login.login"/>">
                        로그인
                    </button>
                </div>
                <div style="margin-top:20px;text-align:center;color:white">
                    <c:if test="${model.error}">
                        <fmt:message key="login.error"/>
                    </c:if>
                </div>
                <!--
                <div class="text-center p-t-90">
                    <a class="txt1" href="#">
                        Forgot Password?
                    </a>
                </div>
                -->
            </form>
        </div>
    </div>
</div>


<div id="dropDownSelect1"></div>

<script type="text/javascript" src="<c:url value="/script/Login_v3/vendor/animsition/js/animsition.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/Login_v3/vendor/bootstrap/js/popper.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/Login_v3/vendor/bootstrap/js/bootstrap.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/Login_v3/vendor/select2/select2.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/Login_v3/vendor/daterangepicker/moment.min.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/Login_v3/vendor/daterangepicker/daterangepicker.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/Login_v3/vendor/countdowntime/countdowntime.js"/>"></script>
<script type="text/javascript" src="<c:url value="/script/Login_v3/js/main.js"/>"></script>
<script type="text/javascript">
    $(document).ready(function() {
        if ( (navigator.appName == 'Netscape' && navigator.userAgent.search('Trident') != -1) || (agent.indexOf("msie") != -1) ) {
            alert("IE 브라우저에서는 사용이 제한됩니다. 다른 브라우저를 사용해 주세요.");
            window.close();
        }
    });
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
                        alert("5분 이내에 접속한 중복접속 기록이 있습니다.\n※다음과 같이 조치가 가능합니다.※\n1) 기존 로그인한 브라우저에서 로그아웃 처리\n2) 5분 뒤 재접속");
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
</body>
</html>
