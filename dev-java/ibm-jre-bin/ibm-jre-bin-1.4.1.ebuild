# Copyright 1999-2004 Gentoo Technologies, Inc.
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ibm-jre-bin/ibm-jre-bin-1.4.1.ebuild,v 1.1 2004/05/01 08:21:30 sejo Exp $
IUSE="doc"

inherit java nsplugins

S="${WORKDIR}/j2sdk${PV}"
DESCRIPTION="IBM Java Development Kit ${PV}"
SRC_URI="ppc?(mirror://IBMJava2-JRE-141.ppc.tgz)
	x86?(mirror://IBMJava2-JRE-141.tgz)"
PROVIDE="virtual/jre-1.4.1
	virtual/java-scheme-2"
SLOT="1.4"
LICENSE="IBM-J1.4"
KEYWORDS="~ppc ppc"


DEPEND="virtual/glibc
	>=dev-java/java-config-0.2.5"
RDEPEND="${DEPEND}"


if [ `use ppc` ]; then
	S=${WORKDIR}/IBMjava2-ppc-141
else
	S=${WORKDIR}/IBMJava2-141
fi;

# No compilation needed!
src_compile() { :; }

src_install() {
	# Copy all the files to the designated directory 
	dodir ${D}opt
	dodir ${D}opt/${P}
	cp -dpR ${S}/jre/* ${D}opt/${P}/

	dohtml -a html,htm,HTML -r docs
	dodoc ${S}/docs/COPYRIGHT

	dodir /etc/env.d/java
	sed \
		-e "s/@P@/${P}/g" \
		-e "s/@PV@/${PV}/g" \
		-e "s/@PF@/${PF}/g" \
		< ${FILESDIR}/ibm-jre-${PV} \
		> ${D}/etc/env.d/java/20ibm-jre-${PV}
}
src_postinst(){
	inst_plugin /opt/${P}/bin/javaplugin.so
	true
}
