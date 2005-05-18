# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ibm-jre-bin/ibm-jre-bin-1.4.2.ebuild,v 1.8 2005/05/18 15:45:12 axxo Exp $

inherit java

S="${WORKDIR}/j2sdk${PV}"
DESCRIPTION="IBM Java Development Kit ${PV}"
HOMEPAGE="http://www-106.ibm.com/developerworks/java/jdk/"
SRC_URI="ppc?(mirror://gentoo/IBMJava2-JRE-142.ppc.tgz)
	ppc64?(mirror://gentoo/IBMJava2-JRE-142.ppc64.tgz)
	x86?(mirror://gentoo/IBMJava2-JRE-142.tgz)"
PROVIDE="virtual/jre"
IUSE="mozilla"
SLOT="1.4"
LICENSE="IBM-J1.4"
KEYWORDS="ppc ~x86 ppc64"
DEPEND="virtual/libc
	>=dev-java/java-config-0.2.5"
RDEPEND=""

if use ppc; then
	S=${WORKDIR}/IBMJava2-ppc-142
elif use ppc64; then
	S=${WORKDIR}/IBMJava2-ppc64-142
else
	S=${WORKDIR}/IBMJava2-142
fi;

src_compile() {
	einfo "${PF} is a binary package, no compilation required"
}

src_install() {
	# Copy all the files to the designated directory
	dodir /opt/${P}
	cp -dpR ${S}/jre/* ${D}/opt/${P}/

	dohtml -a html,htm,HTML -r docs
	dodoc ${S}/docs/COPYRIGHT

	dodir /etc/env.d/java
	sed \
		-e "s/@P@/${P}/g" \
		-e "s/@PV@/${PV}/g" \
		-e "s/@PF@/${PF}/g" \
		< ${FILESDIR}/${P} \
		> ${D}/etc/env.d/java/20${P} \
		|| die "unable to install environment file"

	if useq mozilla && ! ( useq ppc || useq ppc64 ); then
		local plugin="libjavaplugin_oji.so"
		if has_version '>=gcc-3*' ; then
			plugin="libjavaplugin_ojigcc3.so"
		fi
		install_mozilla_plugin /opt/${P}/bin/${plugin}
	fi

}
