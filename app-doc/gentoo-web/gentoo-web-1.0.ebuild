# Copyright 1999-2001 Gentoo Technologies, Inc. Distributed under the terms
# of the GNU General Public License, v2 or later 
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-doc/gentoo-web/gentoo-web-1.0.ebuild,v 1.3 2001/04/10 02:47:47 drobbins Exp $
 
S=${WORKDIR}/${P}
DESCRIPTION="www.gentoo.org website"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org"
RDEPEND="sys-devel/python gnome-libs/libxslt net-www/apache-ssl"

src_unpack() {
	if [ "$MAINTAINER" != "yes" ]
	then
		echo "This will zap stuff in /usr/local/httpd/htdocs."
		echo "Beware -- maintainers only."
	fi
}

src_install() {
	dodir /usr/local/httpd/htdocs/doc
	insinto /usr/local/httpd/htdocs/doc
	cd ${FILESDIR}
	doins html/nvidia_tsg.html
	local x
	for x in install xml-guide dev gentoo-howto
	do
		xsltproc xsl/guide.xsl xml/${x}.xml > ${D}/usr/local/httpd/htdocs/doc/${x}.html
	done
	doins css/gentoo-doc.css images/gentoo-doc.gif images/install*.gif
	
	insinto /usr/local/httpd/htdocs
	doins pyhtml/*
	doins css/gentoo.css
	cd images
	doins gentoolinux.gif gentoo-2.gif
	cd ..
	exeinto /usr/sbin
	doexe bin/update-web
	exeinto /usr/bin
	doexe bin/pytext
}
	
#pkg_postinst() {
	# This doesn't work, appears to be a path/env-update issue
	#/usr/sbin/update-web
#}


