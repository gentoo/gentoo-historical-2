# Copyright 1999-2001 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License, v2 or later
# Maintainer: Tools Team <tools@gentoo.org>
# Author: Karl Trygve Kalleberg <karltk@gentoo.org>
# $Header: /var/cvsroot/gentoo-x86/dev-java/ibm-jre/ibm-jre-1.3.0-r2.ebuild,v 1.1 2002/04/09 22:11:20 karltk Exp $

At=IBMJava2-JRE-13.tgz
S=${WORKDIR}/IBMJava2-13
DESCRIPTION="IBM JRE 1.3.1"
SRC_URI=""
HOMEPAGE="http://www6.software.ibm.com/dl/dklx130/dklx130-p"

DEPEND="virtual/glibc
	>=dev-java/java-config-0.2.1"
RDEPEND="$DEPEND"

PROVIDE="virtual/jre-1.3
	virtual/java-scheme-2"

src_unpack() {
	if [ ! -f ${DISTDIR}/${At} ] ; then
		die "Please download ${At} from ${HOMEPAGE}"
	fi
	unpack ${At} || die
}


src_install () {

	dodir /opt/${P}
	cp -dpR jre/* ${D}/opt/${P}/

	dohtml -a html,htm,HTML -r docs
	dodoc docs/COPYRIGHT

	if [ "`use mozilla`" ] ; then
		dodir /usr/lib/mozilla/plugins
		dosym /opt/${P}/bin/libjavaplugin_oji.so /usr/lib/mozilla/plugins/
	fi
	
	dodir /etc/env.d/java
	sed \
		-e "s/@P@/${P}/g" \
		-e "s/@PV@/${PV}/g" \
		-e "s/@PF@/${PF}/g" \
		< ${FILESDIR}/ibm-jre-${PV} \
		> ${D}/etc/env.d/java/20ibm-jre-${PV}
}

src_postinst() {
	if [ -e /opt/netscape/plugins ] ; then
		ln -sf /opt/${P}/bin/javaplugin.so /opt/netscape/plugins/
		einfo "Netscape 4.x Java plugin installed"
	fi

	if [ "`use mozilla`" ] ; then
                einfo "The Mozilla browser plugin has been installed as /usr/lib/mozilla/plugins/javaplugin_oji.so"
        else
                einfo "To install the browser plugin manually, do:"
		einfo "ln -sf /opt/${P}/bin/libjavaplugin_oji.so /usr/lib/mozilla/plugins/"
        fi

}
