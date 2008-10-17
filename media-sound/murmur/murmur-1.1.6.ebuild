# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/murmur/murmur-1.1.6.ebuild,v 1.2 2008/10/17 01:09:14 tgurr Exp $

EAPI="2"

inherit eutils qt4

MY_PN="mumble"
MY_P=${MY_PN}-${PV}

DESCRIPTION="Voice chat software for gaming written in Qt4 (server)"
HOMEPAGE="http://mumble.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug logrotate pch"

RDEPEND="dev-cpp/Ice
	dev-libs/boost
	|| ( ( x11-libs/qt-core:4[ssl]
			x11-libs/qt-dbus:4
			|| ( x11-libs/qt-sql:4[sqlite] x11-libs/qt-sql:4[mysql] ) )
		=x11-libs/qt-4.3*:4[dbus,ssl,sqlite]
		=x11-libs/qt-4.3*:4[dbus,ssl,mysql] )
	logrotate? ( app-admin/logrotate )"

DEPEND="${RDEPEND}"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	enewgroup murmur
	enewuser murmur -1 -1 /var/lib/murmur murmur
}

src_prepare() {
	sed -i \
		-e 's:mumble-server:murmur:g' \
		scripts/murmur.conf \
		scripts/murmur.ini.system \
		|| die "sed failed."
}

src_configure() {
	use debug && conf_add="${conf_add} symbols debug" || conf_add="${conf_add} release"
	use pch || echo "CONFIG-=precompile_header" >> src/mumble.pri

	eqmake4 main.pro -recursive \
		CONFIG+="${conf_add} no-client no-bundled-speex" \
		|| die "eqmake4 failed."
}

src_install() {
	dodoc README CHANGES || die "Installing docs failed."

	docinto scripts
	dodoc scripts/*.php scripts/*.pl || die "Installing docs failed."

	local dir
	if use debug; then
		dir=debug
	else
		dir=release
	fi

	dobin "${dir}"/murmurd || die "Installing murmurd binary failed."

	insinto /etc/murmur/
	newins scripts/murmur.ini.system murmur.ini || die "Installing murmur.ini configuration file failed."

	if use logrotate; then
		insinto /etc/logrotate.d/
		newins "${FILESDIR}"/murmur.logrotate murmur || die "Installing murmur logrotate file failed."
	fi

	insinto /etc/dbus-1/system.d/
	doins scripts/murmur.conf || die "Installing murmur.conf dbus configuration file failed."

	newinitd "${FILESDIR}"/murmur.initd murmur || die "Installing murmur init.d file failed."
	newconfd "${FILESDIR}"/murmur.confd murmur || die "Installing murmur conf.d file failed."

	keepdir /var/lib/murmur /var/run/murmur /var/log/murmur
	fowners -R murmur /var/lib/murmur /var/run/murmur /var/log/murmur || die "fowners failed."
	fperms 750 /var/lib/murmur /var/run/murmur /var/log/murmur || die "fperms failed."

	doman man/murmurd.1 || die "Installing murmur manpage failed."
}

pkg_postinst() {
	echo
	elog "Useful scripts are located in /usr/share/doc/${PF}/scripts."
	elog "Please execute:"
	elog "murmurd -ini /etc/murmur/murmur.ini -supw <pw>"
	elog "chown murmur:murmur /var/lib/murmur/murmur.sqlite"
	elog "to set the inbuild 'SuperUser' password before starting murmur."
	elog "Please restart dbus before starting murmur,"
	elog "or dbus registration will fail."
	echo
}
