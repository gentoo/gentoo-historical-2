# Copyright 1999-2003 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ibm-jre/ibm-jre-1.4.0-r1.ebuild,v 1.3 2003/02/13 10:09:58 vapier Exp $

inherit nsplugins

At="IBMJava2-JRE-14.tgz"
S="${WORKDIR}/IBMJava2-14"
DESCRIPTION="IBM JRE 1.4.0"
SRC_URI=""
HOMEPAGE="https://www6.software.ibm.com/dl/lxdk/lxdk-p"
IUSE=""
DEPEND="virtual/glibc
	>=dev-java/java-config-0.2.5"
RDEPEND="$DEPEND"
PROVIDE="virtual/jre-1.3.1
	virtual/java-scheme-2"
LICENSE="IBM-ILNWP"
SLOT="1.4"
KEYWORDS="~x86 -ppc -sparc -alpha"

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

	dodir /etc/env.d/java
	sed \
		-e "s/@P@/${P}/g" \
		-e "s/@PV@/${PV}/g" \
		-e "s/@PF@/${PF}/g" \
		< ${FILESDIR}/ibm-jre-${PV} \
		> ${D}/etc/env.d/java/20ibm-jre-${PV}
}

src_postinst() {
	if [ "`use mozilla`" ] ; then
		einfo "The Mozilla browser plugin has been installed as /usr/lib/mozilla/plugins/javaplugin_oji.so"
	else
		einfo "To install the browser plugin manually, do:"
		einfo "ln -sf /opt/${P}/bin/libjavaplugin_oji.so /usr/lib/mozilla/plugins/"
	fi
	true
}
