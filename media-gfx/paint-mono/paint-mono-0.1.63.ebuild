# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/paint-mono/paint-mono-0.1.63.ebuild,v 1.1 2009/05/26 07:23:15 loki_val Exp $

EAPI=2

inherit mono multilib

DESCRIPTION="An unofficial effort to port Paint.NET 3.0 to Linux using Mono."
HOMEPAGE="http://code.google.com/p/paint-mono/"
SRC_URI="http://${PN}.googlecode.com/files/paintdotnet-${PV}.tar.gz"

LICENSE="MIT CCPL-Attribution-NonCommercial-NoDerivs-2.5"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-lang/mono-2.4[-minimal]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/paintdotnet-${PV}"

src_configure() {
	./configure --prefix=/usr
}

src_install() {
	emake DESTDIR="${D}" install
	mono_multilib_comply
	sed -i -e 's:usr/local:usr:' "${D}"/usr/$(get_libdir)/pkgconfig/* "${D}"/usr/bin/*
}
