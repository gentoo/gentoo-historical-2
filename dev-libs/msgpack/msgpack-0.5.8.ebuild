# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/msgpack/msgpack-0.5.8.ebuild,v 1.1 2014/02/12 02:12:48 radhermit Exp $

EAPI="5"
inherit autotools-multilib

DESCRIPTION="MessagePack is a binary-based efficient data interchange format"
HOMEPAGE="http://msgpack.org/ https://github.com/msgpack/msgpack-c/"
SRC_URI="https://github.com/${PN}/${PN}-c/releases/download/cpp-${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="static-libs test"

DEPEND="test? ( dev-cpp/gtest )"

DOCS=( AUTHORS ChangeLog README )
