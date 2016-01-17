<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%--@elvariable id="currentNode" type="org.jahia.services.content.JCRNodeWrapper"--%>
<%--@elvariable id="out" type="java.io.PrintWriter"--%>
<%--@elvariable id="script" type="org.jahia.services.render.scripting.Script"--%>
<%--@elvariable id="scriptInfo" type="java.lang.String"--%>
<%--@elvariable id="workspace" type="java.lang.String"--%>
<%--@elvariable id="renderContext" type="org.jahia.services.render.RenderContext"--%>
<%--@elvariable id="currentResource" type="org.jahia.services.render.Resource"--%>
<%--@elvariable id="url" type="org.jahia.services.render.URLGenerator"--%>

<template:addResources type="css" resources="fileList.css"/>

<template:addResources type="javascript" resources="jquery.min.js"/>
<template:addResources type="javascript" resources="jquery.form.js"/>



<c:set var="targetNodePath" value="${renderContext.mainResource.node.path}"/>
<c:if test="${!empty param.targetNodePath}">
    <c:set var="targetNodePath" value="${param.targetNodePath}"/>
</c:if>
<c:if test="${!empty currentNode.properties.folder}">
    <c:set var="targetNodePath" value="${currentNode.properties.folder.node.path}"/>
</c:if>


<jcr:nodeProperty node="${currentNode}" name="jcr:title" var="title"/>
<c:set var="photoGalleryTitleEscaped" value="${not empty title ? fn:escapeXml(title.string) : ''}"/>


<div class="media-body"><h1>${title.string}</h1> </div>

<div class="photoGalleryHint">Klicken Sie mit der Maus auf eines der kleinen Fotos, um es in Vergr&ouml;&szlig;erung zu sehen. 
  Wenn Sie auf einem gro&szlig;en Foto mit der Maus auf den linken oder rechten Rand gehen, erscheinen Pfeile, um das n&auml;chste bzw. das vorige Foto zu sehen.</div>

<div id="fileList${currentNode.identifier}">
    <jcr:node var="targetNode" path="${targetNodePath}"/>
    <ul class="filesList">
      
    
      
      <c:set var="unsortedNodes" value="${targetNode.nodes}"/> 
      <jcr:sort var="sortedNodes" properties="true,j:fullpath,asc" list="${unsortedNodes}" scope="session"/>
      
      
        <c:forEach items="${sortedNodes}" var="subchild">
            <c:if test="${jcr:isNodeType(subchild, 'jnt:file')}">
                <%-- <li> --%>
                    <jcr:nodeProperty node="${subchild}" name="jcr:title" var="title"/>
                    <jcr:nodeProperty node="${subchild}" name="jcr:name" var="name"/>
                    <c:set var="isImage" value="${fn:startsWith(subchild.fileContent.contentType,'image/')}" />
                        
                        <c:if test="${isImage}">
                            <div class="photoGalleryElement">
                                <a href="<c:url value="${subchild.url}" context="/"/>" data-lightbox="Gallery"><img class="photoGalleryImage" src="${subchild.thumbnailUrls['thumbnail']}"  alt="${fn:escapeXml(subchild.name)}"></a>
                            </div>
                        </c:if>
              <%-- </li> --%>
            </c:if>
        </c:forEach>
    </ul>
</div>

<template:addCacheDependency path="${targetNodePath}"/>