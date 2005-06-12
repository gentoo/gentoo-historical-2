# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-irc/jircii/jircii-35.ebuild,v 1.1 2005/06/12 23:09:36 swegener Exp $

DESCRIPTION="jIRCii - IRC client written in Java"
HOMEPAGE="http://jirc.hick.org/"
SRC_URI="http://jirc.hick.org/download/jerkb${PV}.tgz"
LICENSE="Artistic"
SLOT="0"
KEYWORDS="~x86 ~ppc"
IUSE=""

RDEPEND="virtual/jre"
DEPEND=""

S=${WORKDIR}/jIRCii

src_compile() {
	true
}

src_install() {
	insinto /usr/share/jircii
	doins jerk.jar || die "doins failed"

	cat >${T}/jircii <<EOF
#!/bin/sh
exec java -jar /usr/share/jircii/jerk.jar
EOF
	dobin ${T}/jircii || die "dobin failed"

	dodoc readme.txt whatsnew.txt docs/*.pdf extra/*.irc || die "dodoc failed"
}
