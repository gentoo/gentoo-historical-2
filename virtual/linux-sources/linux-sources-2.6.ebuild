# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/linux-sources/linux-sources-2.6.ebuild,v 1.2 2011/06/30 21:46:17 alexxy Exp $

EAPI=2

DESCRIPTION="Virtual for Linux kernel sources"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE="hardened xrc"

DEPEND=""
RDEPEND="|| (
		hardened? ( =sys-kernel/hardened-sources-2.6* )
		xrc? ( =sys-kernel/cluster-sources-2.6* )
		=sys-kernel/gentoo-sources-2.6*
		=sys-kernel/vanilla-sources-2.6*
		=sys-kernel/cell-sources-2.6*
		=sys-kernel/ck-sources-2.6*
		=sys-kernel/git-sources-2.6*
		=sys-kernel/hardened-sources-2.6*
		=sys-kernel/mips-sources-2.6*
		=sys-kernel/mm-sources-2.6*
		=sys-kernel/openvz-sources-2.6*
		=sys-kernel/pf-sources-2.6*
		=sys-kernel/tuxonice-sources-2.6*
		=sys-kernel/usermode-sources-2.6*
		sys-kernel/vserver-sources
		=sys-kernel/xbox-sources-2.6*
		=sys-kernel/xen-sources-2.6*
		=sys-kernel/zen-sources-2.6*
	)"
