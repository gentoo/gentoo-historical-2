# Copyright 1999-2001 Gentoo Technologies, Inc. Distributed under the terms
# of the GNU General Public License, v2 or later 
# Author Daniel Robbins <drobbins@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/app-doc/gentoo-web/gentoo-web-2.2.ebuild,v 1.18 2001/08/30 19:28:47 drobbins Exp $
 
S=${WORKDIR}/${P}
DESCRIPTION="www.gentoo.org website"
SRC_URI="http://www.red-bean.com/cvs2cl/cvs2cl.pl"
HOMEPAGE="http://www.gentoo.org"
RDEPEND="sys-devel/python gnome-libs/libxslt"

src_unpack() {
	if [ "$MAINTAINER" != "yes" ]
	then
		echo "This will zap stuff in /usr/local/httpd/htdocs."
		echo "Beware -- maintainers only."
	fi
}

src_install() {
	dodir /usr/local/httpd/htdocs/doc
	dodir /usr/local/httpd/htdocs/projects
	insinto /usr/local/httpd/htdocs/doc
	cd ${FILESDIR}
	local x
	for x in build desktop xml-guide portage-user gentoo-howto faq nvidia_tsg openafs
	# (9/13/2001) cvs-tutorial
	do
		xsltproc xsl/guide-main.xsl xml/${x}.xml > ${D}/usr/local/httpd/htdocs/doc/${x}.html || die
	done
	dodir /usr/local/httpd/htdocs/images
	insinto /usr/local/httpd/htdocs/images
	cd ${FILESDIR}/images
	doins paypal.png gtop-s.jpg gbot-s.gif gridtest.gif gentoo-new.gif install*.gif fishhead.gif line.gif icon-* keychain-2.gif
	insinto /usr/local/httpd/htdocs
	doins favicon.ico
	#dynamic firewalls tools page
	cd ${FILESDIR}
	xsltproc xsl/guide-main.xsl xml/dynfw.xml > ${D}/usr/local/httpd/htdocs/projects/dynfw.html	|| die
	xsltproc xsl/guide-main.xsl xml/project-xml.xml > ${D}/usr/local/httpd/htdocs/projects/xml.html	|| die
	
	#both URLs should work
	dodir /usr/local/httpd/htdocs/projects/keychain
	xsltproc xsl/guide-main.xsl xml/keychain.xml > ${D}/usr/local/httpd/htdocs/projects/keychain.html || die	
	xsltproc xsl/guide-main.xsl xml/keychain.xml > ${D}/usr/local/httpd/htdocs/projects/keychain/index.html	|| die
	
	insinto /usr/local/httpd/htdocs/projects
	doins dynfw/dynfw-1.0.1.tar.gz 
	
	cd ..
	tar czvf ${D}/usr/local/httpd/htdocs/projects/guide-xml-latest.tar.gz files 
	cd ${FILESDIR}
	
	insinto /usr/local/httpd/htdocs

	xsltproc xsl/guide-main.xsl xml/main-news.xml > ${D}/usr/local/httpd/htdocs/index.html || die
	xsltproc xsl/guide-main.xsl xml/main-about.xml > ${D}/usr/local/httpd/htdocs/index-about.html || die
	xsltproc xsl/guide-main.xsl xml/main-download.xml > ${D}/usr/local/httpd/htdocs/index-download.html || die
	xsltproc xsl/guide-main.xsl xml/main-projects.xml > ${D}/usr/local/httpd/htdocs/index-projects.html || die

	doins css/main-new.css
	
	#install XSL for later use
	dodir /usr/local/httpd/htdocs/xsl
	insinto /usr/local/httpd/htdocs/xsl
	cd ${FILESDIR}/xsl
	doins cvs.xsl guide-main.xsl

	#install snddevices script
	dodir /usr/local/httpd/htdocs/scripts
	insinto /usr/local/httpd/htdocs/scripts
	cd ${FILESDIR}/scripts
	doins snddevices

	#wikistuffs
	dodir /usr/local/httpd/htdocs/wiki/images
	dodir /usr/local/httpd/htdocs/wiki/bios
	insinto /usr/local/httpd/htdocs/wiki
	cd ${FILESDIR}/wiki
	doins *.php
	cd images
	insinto /usr/local/httpd/htdocs/wiki/images
	doins *.gif
	cd ../bios
	insinto /usr/local/httpd/htdocs/wiki/bios
	doins *.png *.jpg *.gif
	
	cd ${D}
	chmod -R g+rw,o+r *
	chown -R root.root *
	cd ${D}/usr/local/httpd
	chown -R drobbins.webadmin htdocs 
	chmod -R g+rws htdocs

	dobin ${DISTDIR}/cvs2cl.pl
	dosbin ${FILESDIR}/bin/cvslog.sh
	dosbin ${FILESDIR}/bin/wiki.pl
	chmod o-rwx,g+rx ${D}/usr/sbin/wiki.pl
	chown root.dbadmin ${D}/usr/sbin/wiki.pl

	ln -s /home/mailman/icons ${D}/usr/local/httpd/htdocs/mailman-images
}

pkg_preinst() {
	if [ -d /usr/local/httpd/htdocs.bak ]
	then
		rm -rf /usr/local/httpd/htdocs.bak
	fi
	if [ -d /usr/local/httpd/htdocs ]
	then
		cp -ax /usr/local/httpd/htdocs /usr/local/httpd/htdocs.bak
	fi
}

pkg_postinst() {
	source /home/drobbins/.wiki-auth
	cd /usr/local/httpd/htdocs/wiki
	cp functions.php functions.php.orig
	sed -e "s:##USER##:${WIKI_USER}:g" -e "s:##PASS##:${WIKI_PASS}:g" -e "s:##DB##:${WIKI_DB}:g" functions.php.orig > functions.php
	rm functions.php.orig
	cd /usr/sbin
	cp wiki.pl wiki.pl.orig
	sed -e "s:##USER##:${WIKI_USER}:g" -e "s:##PASS##:${WIKI_PASS}:g" -e "s:##DB##:${WIKI_DB}:g" wiki.pl.orig > wiki.pl
	rm wiki.pl.orig
}


