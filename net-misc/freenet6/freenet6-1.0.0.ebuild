# Copyright 1999-2006 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/freenet6/freenet6-1.0.0.ebuild,v 1.9 2006/06/28 16:32:10 wolf31o2 Exp $

inherit toolchain-funcs

DESCRIPTION="Client to configure an IPv6 tunnel to freenet6 (tspc)"
HOMEPAGE="http://www.freenet6.net/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="VPL-1.0"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ~sparc x86"
IUSE=""

DEPEND=""

S="${WORKDIR}/freenet6-client-1.0"

pkg_setup() {
	case ${CHOST} in
		*-openbsd*)					OS=openbsd ;;
		*-freebsd* | *-dragonfly*)	OS=freebsd44 ;;
		*-netbsd*)					OS=netbsd ;;
		*-linux*)					OS=linux ;;
		*)
			die "Unknown target, please report this error after checking your CHOST."
			;;
	esac
}

src_unpack() {
	unpack ${A}
	cd "${S}"

	sed -i -e 's:\$(CC) -c:$(CC) $(CFLAGS) -c:' \
		-e 's:\$(CC) \$(OBJDIR):$(CC) $(LDFLAGS) $(OBJDIR):' \
		src/Makefile
}

src_compile() {
	emake all CC="$(tc-getCC)" target="${OS}" || die "Build Failed"
}

src_install() {
	dosbin bin/tspc || die

	insopts -m 600
	insinto /etc/freenet6
	doins ${FILESDIR}/tspc.conf
	exeinto /etc/freenet6/template
	doexe template/{${OS},checktunnel}.sh
	doexe ${FILESDIR}/gentoo.sh

	dodoc CONTRIB.txt LEGAL README
	doman man/{man5/tspc.conf.5,man8/tspc.8}

	exeinto /etc/init.d
	newexe ${FILESDIR}/tspc.rc tspc
}

pkg_postinst() {
	einfo "The freenet6 ebuild installs an init script named 'tspc'"
	einfo "to coincide with the name of the client binary installed"
	einfo "To add support for a freenet6 connection at startup, do"
	einfo ""
	einfo "# rc-update add tspc default"
}
