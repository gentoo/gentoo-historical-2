# Copyright 1999-2004 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ibm-jdk-bin/ibm-jdk-bin-1.4.2.ebuild,v 1.15 2004/11/20 09:42:44 sejo Exp $

inherit java eutils

DESCRIPTION="IBM Java Development Kit ${PV}"
SRC_URI="ppc? ( mirror://gentoo/IBMJava2-SDK-142.ppc.tgz )
	ppc64? ( mirror://gentoo/IBMJava2-SDK-142.ppc64.tgz )
	x86? ( mirror://gentoo/IBMJava2-SDK-142.tgz )
	amd64? (mirror://gentoo/IBMJava2-SDK-AMD64-142.x86_64.tgz )
	javacomm? (
		x86? ( mirror://gentoo/IBMJava2-JAVACOMM-142.tgz )
		ppc64? ( mirror://gentoo/IBMJava2-JAVACOMM-142.tgz )
		amd64? ( mirror://gentoo/IBMJava2-JAVACOMM-AMD64-142.x86_64.tgz )
		)"
PROVIDE="virtual/jdk-1.4.2
	virtual/jre-1.4.2
	virtual/java-scheme-2"
SLOT="1.4"
LICENSE="IBM-J1.4"
KEYWORDS="~ppc ~x86 ppc64 ~amd64"

DEPEND="virtual/libc
	>=dev-java/java-config-0.2.5
	doc? ( =dev-java/java-sdk-docs-1.4.2* )
	X? ( virtual/x11 )"
RDEPEND=" !ppc64? (!amd64? sys-libs/lib-compat)"

IUSE="X doc javacomm mozilla"

if use ppc; then
	S="${WORKDIR}/IBMJava2-ppc-142"
elif use ppc64; then
	S="${WORKDIR}/IBMJava2-ppc64-142"
elif use amd64; then
	S="${WORKDIR}/IBMJava2-amd-142"
else
	S="${WORKDIR}/IBMJava2-142"
fi

src_compile() { :; }

src_install() {
	# Copy all the files to the designated directory
	mkdir -p ${D}opt/${P}
	cp -dpR ${S}/{bin,jre,lib,include} ${D}opt/${P}/

	mkdir -p ${D}/opt/${P}/share
	cp -a ${S}/{demo,src.jar} ${D}opt/${P}/share/

	# setting the ppc stuff
	if useq ppc; then
		dosed s:/proc/cpuinfo:/etc//cpuinfo:g /opt/${P}/jre/bin/libjitc.so
		dosed s:/proc/cpuinfo:/etc//cpuinfo:g /opt/${P}/jre/bin/libjitc_g.so
		insinto /etc
		doins ${FILESDIR}/cpuinfo
	fi

	if useq mozilla && ! useq ppc; then
		local plugin="libjavaplugin_oji.so"
		if has_version '>=gcc-3*' ; then
			plugin="libjavaplugin_ojigcc3.so"
		fi
		install_mozilla_plugin /opt/${P}/jre/bin/${plugin}
	fi

	dohtml -a html,htm,HTML -r docs
	dodoc ${S}/docs/COPYRIGHT

	set_java_env ${FILESDIR}/${VMHANDLE}

}

pkg_postinst() {
	java_pkg_postinst
	if ! useq X; then
		echo
		eerror "You're not using X so its possible that you dont have"
		eerror "a X server installed, please read the following warning: "
		eerror "Some parts of IBM JDK require XFree86 to be installed."
		eerror "Be careful which Java libraries you attempt to use."
	fi

	ebeep 5
	epause 8
}
