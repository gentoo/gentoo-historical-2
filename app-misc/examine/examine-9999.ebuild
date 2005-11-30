# Copyright 1999-2005 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/examine/examine-9999.ebuild,v 1.1.1.1 2005/11/30 10:05:48 chriswhite Exp $

inherit enlightenment

DESCRIPTION="configuration library for applications based on the EFL"

DEPEND=">=dev-libs/eet-0.9.0
	>=dev-db/edb-1.0.5
	>=x11-libs/ewl-0.0.4
	>=x11-libs/ecore-0.9.9
	sys-libs/readline"
