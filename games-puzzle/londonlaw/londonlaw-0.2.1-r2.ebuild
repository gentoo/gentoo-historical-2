# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-puzzle/londonlaw/londonlaw-0.2.1-r2.ebuild,v 1.1 2008/08/24 06:36:05 mr_bones_ Exp $

EAPI=1
inherit eutils python games

DESCRIPTION="Clone of the famous Scotland Yard board game"
HOMEPAGE="http://pessimization.com/software/londonlaw/"
SRC_URI="http://pessimization.com/software/londonlaw/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dedicated"

DEPEND=">=dev-lang/python-2.3
	!dedicated? ( dev-python/wxpython:2.6 )
	dev-python/twisted"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch \
		"${FILESDIR}"/${P}-setup.py.patch \
		"${FILESDIR}"/${P}-wxversion.patch
	if has_version '>=dev-python/twisted-2.3' ; then
		sed -i \
			-e 's:import log:import log\nfrom zope import interface\n:' \
			-e 's:class IGameListener(components.Interface):class IGameListener(interface.Interface):' \
			londonlaw/server/Game.py \
			|| die "sed failed"
	fi

	if use dedicated ; then
		local f
		rm -r londonlaw/{london-client,london-client.py,guiclient/}
		sed -i \
			-e "s:'londonlaw.guiclient'::" \
			-e "s:'londonlaw/london-client'::" \
			setup.py \
			|| die "sed failed"
		for f in londonlaw.rc londonlaw.confd
		do
			sed \
				-e "s/GAMES_USER_DED/${GAMES_USER_DED}/" \
				-e "s:GAMES_BINDIR:${GAMES_BINDIR}:" \
				"${FILESDIR}/${f}" > "${T}/${f}" \
				|| die "sed failed"
		done
	fi
}

src_install() {
	python_version
	python setup.py install \
		--root="${D}" \
		--prefix="${GAMES_PREFIX}" \
		--install-lib=/usr/lib/python${PYVER}/site-packages \
		--install-data="${GAMES_DATADIR}" \
		|| die "install failed"
	dodoc ChangeLog README

	if use dedicated ; then
		newinitd "${T}/londonlaw.rc" londonlaw
		newconfd "${T}/londonlaw.confd" londonlaw
		insinto /var/log
		newins /dev/null londonlaw.log
		fowners ${GAMES_USER_DED}:${GAMES_GROUP} /var/log/londonlaw.log
	fi

	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	if ! use dedicated ; then
		echo
		elog "To play, first start the server (london-server), then connect"
		elog "with the client (london-client).  At least two players are"
		elog "needed to play."
		echo
	fi
}
