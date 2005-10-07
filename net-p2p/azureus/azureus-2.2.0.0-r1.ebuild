# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-p2p/azureus/azureus-2.2.0.0-r1.ebuild,v 1.4 2005/10/07 16:51:53 axxo Exp $

DESCRIPTION="Azureus - Java BitTorrent Client"
HOMEPAGE="http://azureus.sourceforge.net/"
SRC_URI="mirror://sourceforge/azureus/Azureus_${PV}_source.zip
		mirror://gentoo/seda-20040224.zip"
LICENSE="GPL-2 BSD"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND=">=virtual/jre-1.4
	>=dev-java/swt-3.0-r2
	>=dev-java/log4j-1.2.8
	>=dev-java/commons-cli-1.0
	>=dev-java/systray4j-2.4"
DEPEND=">=virtual/jdk-1.4
	${RDEPEND}
	>=dev-java/ant-core-1.6.2
	>=app-arch/unzip-5.0
	!net-p2p/azureus-bin"

S=${WORKDIR}/${PN}

src_unpack() {
	local PROGRAM_DIR="/usr/lib/${PN}"

	mkdir ${S} && cd ${S}
	unpack ${A}
	cp ${FILESDIR}/build.xml ${S} || die "cp build.xml failed"

	#removing osx files and entries
	cp -f  ${FILESDIR}/SWTThread.java \
		${S}/org/gudy/azureus2/ui/swt/mainwindow/SWTThread.java \
		|| die "cp SWTThread.java failed!"

	# copying the shell to run the app
	cp ${FILESDIR}/azureus-gentoo.sh ${S}/azureus \
		|| die "cp azureus-gentoo.sh filed"

	# Set runtime settings in the startup script
	sed -i "s:##PROGRAM_DIR##:${PROGRAM_DIR}:" ${S}/azureus \
		|| die "sed azureus program dir failed !"
	rm -fr org/gudy/azureus2/ui/swt/osx org/gudy/azureus2/ui/swt/test
}

src_compile() {
	# Figure out correct boot classpath
	if [ ! -z "$(java-config --java-version | grep IBM)" ] ; then
		# IBM JRE
		ant_extra_opts="-Dbootclasspath=$(java-config --jdk-home)/jre/lib/core.jar:$(java-config --jdk-home)/jre/lib/xml.jar:$(java-config --jdk-home)/jre/lib/graphics.jar"
	else
		# Sun derived JREs (Blackdown, Sun)
		ant_extra_opts="-Dbootclasspath=$(java-config --jdk-home)/jre/lib/rt.jar"
	fi
	ant -q -q \
		-buildfile build.xml ${ant_extra_opts} jar \
		|| die "ant build failed"
}

src_install() {
	local PROGRAM_DIR="/usr/lib/${PN}"

	insinto ${PROGRAM_DIR}
	doins *.jar || die "doins jar failed"
	dobin azureus || die "dobin /usr/bin/azureus failed"
	insinto /usr/share/pixmaps
	doins "${FILESDIR}/azureus.png"
	insinto /usr/share/applications
	doins "${FILESDIR}/azureus.desktop"
	dodoc seda-README.txt

	ewarn "Please do not run azureus as root!"
	ewarn "Azureus has not been developed for multi-user environments!!!!!"
}
