# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ant-apache-regexp/ant-apache-regexp-1.7.0.ebuild,v 1.4 2007/01/25 18:20:52 wltjr Exp $

ANT_TASK_DEPNAME="jakarta-regexp-1.4"

inherit ant-tasks

KEYWORDS="~amd64 ~ppc64 ~x86 ~x86-fbsd"

# could use slot deps
DEPEND="=dev-java/jakarta-regexp-1.4*"
RDEPEND="${DEPEND}"
